import SwiftUI
import Observation

@Observable
final class BookScannerViewModel {
    
    var items: [BookProcessItem] = []
    var isProcessing: Bool = false
    var errorMessage: String?
    
    private let ocrService: OCRServiceProtocol
    private let aiService: AIContentServiceProtocol
    private var settingsService: SettingsServiceProtocol
    
    init(ocrService: OCRServiceProtocol,
         aiService: AIContentServiceProtocol,
         settingsService: SettingsServiceProtocol) {
        self.ocrService = ocrService
        self.aiService = aiService
        self.settingsService = settingsService
    }
    
    func addImages(_ images: [UIImage]) {
        let newItems = images.map {
            BookProcessItem(id: UUID(), originalImage: $0, status: .idle, result: nil)
        }
        items.append(contentsOf: newItems)
    }
    
    func removeWrapper(id: UUID) {
        items.removeAll { $0.id == id }
    }
    
    @MainActor
    func processAllItems() {
        guard !isProcessing else { return }
        isProcessing = true
        errorMessage = nil
        
        let itemsToProcess = items.filter { $0.status != .success }
        
        Task {
            await withTaskGroup(of: (UUID, BookProcessItem).self) { group in
                for item in itemsToProcess {
                    group.addTask {
                        var updatedItem = item
                        updatedItem.status = .processing
                        return (item.id, updatedItem)
                    }
                    
                    group.addTask { [weak self] in
                        guard let self = self else { return (item.id, item) }
                        var processingItem = item
                        
                        do {
                            let rawText = try await self.ocrService.extractText(from: item.originalImage)
                            if rawText.isEmpty { throw AppError.ocrFailed }
                            
                            let domains = self.settingsService.targetDomains
                            let result = try await self.aiService.identifyAndDescribe(rawText: rawText, allowedDomains: domains)
                            
                            processingItem.result = result
                            processingItem.status = .success
                            
                        } catch {
                            processingItem.status = .failure(error.localizedDescription)
                        }
                        
                        return (item.id, processingItem)
                    }
                }
                
                for await (id, updatedItem) in group {
                    if let index = self.items.firstIndex(where: { $0.id == id }) {
                        if self.items[index].status != updatedItem.status {
                            self.items[index] = updatedItem
                        }
                    }
                }
            }
            self.isProcessing = false
        }
    }
    
    func generateFinalClipboardString() -> String {
        let prefix = settingsService.prefixText
        let successfulItems = items.compactMap { $0.result }
        
        let formattedStrings = successfulItems.map { result in
            """
            \(result.title) - \(result.author) \(prefix)
            
            \(result.description)
            Source: \(result.sourceUrl)
            """
        }
        return formattedStrings.joined(separator: "\n\n---\n\n")
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = generateFinalClipboardString()
    }
}
