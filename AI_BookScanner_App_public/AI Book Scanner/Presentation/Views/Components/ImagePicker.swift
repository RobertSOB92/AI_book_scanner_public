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
