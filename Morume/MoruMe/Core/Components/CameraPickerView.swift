//
//  CameraPickerView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import CoreImage
import SwiftUI

struct CameraPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.cameraDevice = .front
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: Context
    ) {}

    class Coordinator: NSObject, UINavigationControllerDelegate,
        UIImagePickerControllerDelegate
    {
        let parent: CameraPickerView

        init(_ parent: CameraPickerView) {
            self.parent = parent
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                print("Image selected: \(image.imageOrientation.rawValue)")
                parent.selectedImage = correctImageOrientation(image)
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.selectedImage = nil
            picker.dismiss(animated: true)
        }

        func correctImageOrientation(_ image: UIImage) -> UIImage {
            // If already upright, nothing to do.
            guard image.imageOrientation != .up,
                let cgImage = image.cgImage
            else { return image }

            // Rotate the pixel buffer using Core Image while preserving the original color space.
            let ciInput = CIImage(cgImage: cgImage)
            let oriented = ciInput.oriented(CGImagePropertyOrientation(image.imageOrientation))

            // CIContext with nil color‑space preserves channels exactly as‑is.
            let context = CIContext(options: [
                .workingColorSpace: NSNull(),
                .outputColorSpace: NSNull()
            ])

            guard let cgOutput = context.createCGImage(oriented, from: oriented.extent) else {
                return image
            }

            return UIImage(cgImage: cgOutput, scale: image.scale, orientation: .up)
        }
    }
}

extension CGImagePropertyOrientation {
    fileprivate init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
