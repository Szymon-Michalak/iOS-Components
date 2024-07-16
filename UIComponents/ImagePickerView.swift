import SwiftUI
import UIKit

/// A SwiftUI view that presents an image picker.
struct ImagePickerView: UIViewControllerRepresentable {
    
    // MARK: - Stored Properties
    
    @Environment(\.presentationMode) private var presentationMode

    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (Data) -> Void
    
    // MARK: - Initialization

    /**
     Initializes the ImagePickerView with the specified source type and a closure to handle the picked image.
     
     - Parameters:
        - sourceType: The source type for the image picker (e.g., .photoLibrary, .camera).
        - onImagePicked: A closure to handle the picked image data.
     
     - Usage:
     ```swift
     ImagePickerView(sourceType: .photoLibrary) { imageData in
         // Handle the picked image data
     }
     ```
     
     - Time Complexity: O(1)
     - Space Complexity: O(1)
     - Use Cases: Integrating an image picker into a SwiftUI view.
     - Dependencies: SwiftUI, UIKit
     - Swift Version: 5.3+
     - Platform: iOS 14.0+
     */
    init(
        sourceType: UIImagePickerController.SourceType,
        onImagePicked: @escaping (Data) -> Void)
    {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    // MARK: - Methods

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { presentationMode.wrappedValue.dismiss() },
            onImagePicked: onImagePicked
        )
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        // MARK: - Stored Properties
        
        private let onDismiss: () -> Void
        private let onImagePicked: (Data) -> Void

        // MARK: - Initialization
        
        init(
            onDismiss: @escaping () -> Void,
            onImagePicked: @escaping (Data) -> Void
        ) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        // MARK: - Methods

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage,
               let imageData = image.jpegData(compressionQuality: 1.0) {
                onImagePicked(imageData)
            }
            onDismiss()
        }

        func imagePickerControllerDidCancel(_: UIImagePickerController) {
            onDismiss()
        }

    }

}

// MARK: - Usage Example

struct ContentView: View {
    @State private var isImagePickerPresented = false
    @State private var imageData: Data?

    var body: some View {
        VStack {
            if let data = imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

            Button("Pick Image") {
                isImagePickerPresented = true
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerView(sourceType: .photoLibrary) { data in
                self.imageData = data
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
