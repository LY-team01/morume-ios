//
//  ImageUploadComponent.swift
//  MoruMe
//
//  Created by malab-nakazono on 2025/05/20.
//

import SwiftUI

private struct SelectImageComponent: View {
    @Binding var selectedImage: UIImage?
    @Binding var showLibraryPicker: Bool
    let iconAsset: ImageResource
    var body: some View {
        Button {
            showLibraryPicker = true
        } label: {
            VStack(spacing: 20) {
                Image(iconAsset)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.moruMePink)
                    .frame(width: 128, height: 128)
                Text("写真ライブラリから選択")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.moruMePink)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 70)
            .padding(.bottom, 80)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(uiColor: .systemGray6))
            }
        }
    }
}

struct ImageUploadComponent: View {
    @Binding var selectedImage: UIImage?
    @State private var showCameraPicker = false
    @State private var showLibraryPicker = false

    let mainMessage: String
    let optionalSubMessage: String?
    let iconAsset: ImageResource

    init(
        selectedImage: Binding<UIImage?>,
        mainMessage: String,
        optionalSubMessage: String? = nil,
        iconAsset: ImageResource
    ) {
        self._selectedImage = selectedImage
        self.mainMessage = mainMessage
        self.optionalSubMessage = optionalSubMessage
        self.iconAsset = iconAsset
    }

    var body: some View {
        VStack {
            Text(mainMessage)
                .font(.system(size: 21))
                .foregroundStyle(.moruMePink)
            if let subMessage = optionalSubMessage {
                Text(subMessage)
                    .font(.system(size: 13))
                    .foregroundStyle(.moruMePink)
            }
            SelectImageComponent(
                selectedImage: $selectedImage,
                showLibraryPicker: $showLibraryPicker,
                iconAsset: iconAsset
            )
            Text("or")
                .font(.system(size: 24))
                .foregroundStyle(.moruMePink)
            Button {
                showCameraPicker = true
            } label: {
                Text("写真を撮る")
                    .foregroundStyle(.white)
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.moruMePink)
                    }
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 27)
                .fill(.white)
                .shadow(color: .black.opacity(0.25), radius: 18, x: 4, y: 4)
        }
        .fullScreenCover(isPresented: $showCameraPicker) {
            CameraPickerView(selectedImage: $selectedImage)
        }
        .fullScreenCover(isPresented: $showLibraryPicker) {
            LibraryPickerView(selectedImage: $selectedImage)
        }
    }
}

#Preview {
    ImageUploadComponent(
        selectedImage: .constant(nil),
        mainMessage: "写真をアップロードしてください",
        iconAsset: .photoLibraryIcon
    )
}
