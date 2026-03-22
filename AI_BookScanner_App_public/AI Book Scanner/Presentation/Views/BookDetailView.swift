import SwiftUI

struct BookDetailView: View {
    let book: BookResult
    
    // Używamy Twojego serwisu ustawień
    private let settings = UserDefaultsSettingsService()
    
    @State private var copiedHeader = false
    @State private var copiedContent = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // --- SEKCJA 1: TYTUŁ I AUTOR ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Nagłówek")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(book.author)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: copyHeader) {
                        HStack {
                            Image(systemName: copiedHeader ? "checkmark" : "doc.on.doc")
                            Text(copiedHeader ? "Skopiowano nagłówek" : "Kopiuj: Tytuł - Autor")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(copiedHeader ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                        .foregroundColor(copiedHeader ? .green : .blue)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // --- SEKCJA 2: PREFIX I OPIS ---
                VStack(alignment: .leading, spacing: 12) {
                    Text("Treść posta")
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        if !settings.prefixText.isEmpty {
                            Text(settings.prefixText)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                                .padding(.bottom, 2)
                        }
                        
                        Text(book.description)
                            .font(.body)
                            .lineSpacing(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: copyContent) {
                        HStack {
                            Image(systemName: copiedContent ? "checkmark" : "text.append")
                            Text(copiedContent ? "Skopiowano treść" : "Kopiuj: Prefix + Opis")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(copiedContent ? Color.green.opacity(0.2) : Color.blue.opacity(0.1))
                        .foregroundColor(copiedContent ? .green : .blue)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // --- SEKCJA 3: NAPRAWIONY LINK (SMART SEARCH) ---
                // Zamiast ufać AI, sami generujemy link do wyszukiwania
                if let searchURL = generateSearchURL() {
                    Link(destination: searchURL) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                            Text("Znajdź informacje w Google")
                            Image(systemName: "arrow.up.right")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue) // Wyraźny przycisk
                        .cornerRadius(12)
                    }
                    .padding(.top)
                }
            }
            .padding()
        }
        .navigationTitle("Podgląd")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // --- FUNKCJE POMOCNICZE ---
    
    // Ta funkcja naprawia problem z linkami.
    // Tworzy zapytanie do Google: "Tytuł Autor site:twoja_domena"
    private func generateSearchURL() -> URL? {
        // 1. Bierzemy tytuł i autora
        var query = "\(book.title) \(book.author)"
        
        // 2. Jeśli użytkownik ustawił domeny (np. lubimyczytac.pl), dodajemy to do wyszukiwania
        // Bierzemy pierwszą domenę z listy, jeśli istnieje
        if let firstDomain = settings.targetDomains.first, !firstDomain.isEmpty {
            query += " site:\(firstDomain)"
        }
        
        // 3. Kodujemy spacje i polskie znaki do formatu URL
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return nil
        }
        
        // 4. Zwracamy pewny link do Google
        return URL(string: "https://www.google.com/search?q=\(encodedQuery)")
    }
    
    private func copyHeader() {
        let textToCopy = "\(book.title) - \(book.author)"
        UIPasteboard.general.string = textToCopy
        withAnimation { copiedHeader = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { copiedHeader = false } }
    }
    
    private func copyContent() {
        var textToCopy = ""
        let currentPrefix = settings.prefixText
        if !currentPrefix.isEmpty { textToCopy += "\(currentPrefix)\n\n" }
        textToCopy += book.description
        UIPasteboard.general.string = textToCopy
        withAnimation { copiedContent = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { copiedContent = false } }
    }
}
