import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    private var settingsService = UserDefaultsSettingsService()
    
    @State private var prefix: String = ""
    @State private var domainsInput: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
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
            }
        }
    }
    
    private func saveSettings() {
        settingsService.prefixText = prefix
        let domains = domainsInput.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        settingsService.targetDomains = domains
    }
}
