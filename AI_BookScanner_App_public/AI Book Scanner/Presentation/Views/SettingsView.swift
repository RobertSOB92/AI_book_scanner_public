import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    private var settingsService = UserDefaultsSettingsService()

    @State private var prefix: String = ""
    @State private var domainsInput: String = ""
    @State private var geminiApiKey: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Gemini API Key"), footer: Text("Wklej własny klucz API z Google AI Studio. Bez klucza funkcja AI nie będzie działać.")) {
                    SecureField("Klucz Api", text: $geminiApiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }

                Section(header: Text("Prefix dla Social Media")) {
                    TextField("Np. #Polecajka", text: $prefix, axis: .vertical)
                }
                Section(header: Text("Preferowane Domeny"), footer: Text("Oddziel domeny przecinkami")) {
                    TextField("np. lubimyczytac.pl, empik.com", text: $domainsInput, axis: .vertical)
                }
            }
            .navigationTitle("Ustawienia")
            .toolbar {
                Button("Gotowe") {
                    saveSettings()
                    dismiss()
                }
            }
            .onAppear {
                prefix = settingsService.prefixText
                domainsInput = settingsService.targetDomains.joined(separator: ", ")
                geminiApiKey = settingsService.geminiApiKey
            }
        }
    }

    private func saveSettings() {
        settingsService.prefixText = prefix
        settingsService.geminiApiKey = geminiApiKey
        let domains = domainsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        settingsService.targetDomains = domains
    }
}
