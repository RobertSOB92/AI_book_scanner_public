import SwiftUI
import PhotosUI

struct ScannerView: View {
    @State private var viewModel: BookScannerViewModel
    @State private var showingImagePicker = false
    @State private var showSettings = false

    // Nowy stan do obsługi potwierdzenia usunięcia
    @State private var showClearConfirmation = false
    @State private var showMissingApiKeyAlert = false

    init() {
        let settings = UserDefaultsSettingsService()
        let ocr = VisionOCRService()
        let ai = GeminiAIService(settingsService: settings)

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
                            // Logika nawigacji (taka jak wcześniej)
                            if let result = item.result {
                                NavigationLink(destination: BookDetailView(book: result)) {
                                    BookItemRow(item: item)
                                }
                            } else {
                                BookItemRow(item: item)
                            }
                        }
                        .onDelete { indexSet in
                            // Usuwanie pojedyncze (przesunięciem palca)
                            indexSet.forEach { index in
                                viewModel.removeWrapper(id: viewModel.items[index].id)
                            }
                        }
                    }
                }

                // Panel przycisków na dole
                HStack(spacing: 20) {
                    Button(action: { showingImagePicker = true }) {
                        Label("Dodaj Zdjęcia", systemImage: "photo.on.rectangle")
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.isProcessing)

                    Button(action: {
                        let settings = UserDefaultsSettingsService()
                        if settings.geminiApiKey.isEmpty {
                            showMissingApiKeyAlert = true
                        } else {
                            viewModel.processAllItems()
                        }
                    }) {
                        if viewModel.isProcessing {
                            ProgressView()
                        } else {
                            Label("Przetwórz", systemImage: "wand.and.stars")
                        }
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

                // --- ZMIANA TUTAJ: PRZYCISK KOSZA ---
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // Wywołujemy alert potwierdzenia
                        showClearConfirmation = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red) // Czerwony kolor ostrzegawczy
                    }
                    // Przycisk nieaktywny, jeśli lista jest pusta
                    .disabled(viewModel.items.isEmpty)
                }
            }
            // --- OKNO POTWIERDZENIA USUNIĘCIA ---
            .alert("Wyczyścić wszystko?", isPresented: $showClearConfirmation) {
                Button("Anuluj", role: .cancel) { }
                Button("Usuń", role: .destructive) {
                    // Czyścimy listę
                    viewModel.items.removeAll()
                }
            } message: {
                Text("Ta operacja usunie wszystkie dodane zdjęcia i wygenerowane opisy.")
            }
            .alert("Brak klucza API", isPresented: $showMissingApiKeyAlert) {
                Button("Anuluj", role: .cancel) { }
                Button("Otwórz ustawienia") {
                    showSettings = true
                }
            } message: {
                Text("Aby korzystać z AI, wklej swój Gemini API key w Ustawieniach.")
            }
            // -------------------------------------
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerWrapper(images: { images in viewModel.addImages(images) })
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
        }
    }
}
