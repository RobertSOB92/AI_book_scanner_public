import SwiftUI
import PhotosUI

struct ImagePickerWrapper: UIViewControllerRepresentable {
    var images: ([UIImage]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 10
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerWrapper
        init(parent: ImagePickerWrapper) { self.parent = parent }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let group = DispatchGroup()
            var pickedImages: [UIImage] = []
            
            for result in results {
                group.enter()
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage { pickedImages.append(image) }
                        group.leave()
                    }
                } else { group.leave() }
            }
            group.notify(queue: .main) { self.parent.images(pickedImages) }
        }
    }
}
cat <<EOF > "/Users/rosobotka/Desktop/AI_BookScanner_App/Presentation/Views/Components/BookItemRow.swift"
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
