import SwiftUI

struct BookItemRow: View {
    let item: BookProcessItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(uiImage: item.originalImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 80)
                .cornerRadius(6)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                if let result = item.result {
                    Text(result.title).font(.headline)
                    Text(result.author).font(.subheadline).foregroundStyle(.secondary)
                    Text("Source: " + result.sourceUrl).font(.caption2).lineLimit(1).foregroundStyle(.blue)
                } else {
                    Text("Oczekuje na przetworzenie...").font(.subheadline).foregroundStyle(.gray)
                }
                Spacer()
                statusView
            }
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder var statusView: some View {
        switch item.status {
        case .idle: EmptyView()
        case .processing: HStack { ProgressView().controlSize(.mini); Text("Przetwarzanie...").font(.caption) }
        case .success: Label("Gotowe", systemImage: "checkmark.circle.fill").font(.caption).foregroundStyle(.green)
        case .failure(let msg): Label(msg, systemImage: "exclamationmark.triangle.fill").font(.caption).foregroundStyle(.red)
        }
    }
}

