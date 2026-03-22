import SwiftUI
import PhotosUI

struct ScannerView: View {
    @State private var viewModel: BookScannerViewModel
    @State private var showingImagePicker = false
    @State private var showSettings = false
    
    init() {
        let settings = UserDefaultsSettingsService()
        let ocr = VisionOCRService()
        let ai = GeminiAIService(apiKey: "YOUR_API_KEY") // WPISZ TU SWÓJ KLUCZ!
        
        let vm = BookScannerViewModel(ocrService: ocr, aiService: ai, settingsService: settings)
        _viewModel = State(initialValue: vm)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.items.isEmpty {
                    ContentUnavailableView("Brak książek", systemImage: "books.vertical", description: Text("Dodaj zdjęcia, aby rozpocząć"))
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            BookItemRow(item: item)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                viewModel.removeWrapper(id: viewModel.items[index].id)
                            }
                        }
                    }
                }
                
                HStack(spacing: 20) {
                    Button(action: { showingImagePicker = true }) {
                        Label("Dodaj Zdjęcia", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isProcessing)
                    
                    Button(action: { viewModel.processAllItems() }) {
                        if viewModel.isProcessing { ProgressView() } else { Label("Przetwórz", systemImage: "wand.and.stars") }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.items.isEmpty || viewModel.isProcessing)
                }
                .padding()
            }
            .navigationTitle("AI Book Scanner")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showSettings = true }) { Image(systemName: "gear") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kopiuj Wszystkie") { viewModel.copyToClipboard() }
                    .disabled(viewModel.items.filter { $0.status == .success }.isEmpty)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerWrapper(images: { images in viewModel.addImages(images) })
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }
}
