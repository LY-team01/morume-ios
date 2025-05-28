//
//  LibraryPickerView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import PhotosUI
import SwiftUI

struct LibraryPickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        picker.view.tintColor = .moruMePink
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: PHPickerViewControllerDelegate {
        let parent: LibraryPickerView

        init(_ parent: LibraryPickerView) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else {
                parent.selectedImage = nil
                picker.dismiss(animated: true)
                return
            }

            // PHAssetのローカル識別子を取得
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, _) in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = uiImage
                        picker.dismiss(animated: true)
                    }
                } else if let assetId = result.assetIdentifier {
                    // iCloud上の画像をダウンロード
                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
                    if let asset = fetchResult.firstObject {
                        let options = PHImageRequestOptions()
                        options.isNetworkAccessAllowed = true // iCloudからのダウンロードを許可
                        options.deliveryMode = .highQualityFormat
                        options.isSynchronous = false

                        PHImageManager.default().requestImage(
                            for: asset,
                            targetSize: PHImageManagerMaximumSize,
                            contentMode: .default,
                            options: options
                        ) { downloadedImage, _ in
                            guard let image = downloadedImage else { return }
                            DispatchQueue.main.async {
                                self?.parent.selectedImage = image
                                picker.dismiss(animated: true)
                            }
                        }
                    } else {
                        // 画像取得できなかった場合
                        DispatchQueue.main.async {
                            self?.parent.selectedImage = nil
                            picker.dismiss(animated: true)
                        }
                    }
                } else {
                    // どちらの方法でも取得できなかった場合
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = nil
                        picker.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
