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
            VStack(spacing: 8) {
                Image(iconAsset)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.moruMePink)
                    .frame(width: 128, height: 128)
                Text("写真ライブラリから選択")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.moruMePink)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 52)
        .padding(.horizontal, 25)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct ImageUploadComponent: View {
    @Binding var selectedImage: UIImage?
    let mainMessage: String
    let optionalSubMessage: String?
    let iconAsset: ImageResource
    @State private var showCameraPicker = false
    @State private var showLibraryPicker = false
    var body: some View {
        VStack {
            Text(mainMessage)
                .foregroundColor(.moruMePink)
                .font(.system(size: 21))
            if let subMessage = optionalSubMessage {
                Text(subMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.moruMePink)
            }
            SelectImageComponent(
                selectedImage: $selectedImage,
                showLibraryPicker: $showLibraryPicker,
                iconAsset: iconAsset
            )
            Text("or")
                .foregroundColor(.moruMePink)
                .font(.system(size: 24))
            Button {
                showCameraPicker = true
            } label: {
                Text("写真を撮る")
                    .font(.system(size: 17))
                    .frame(maxWidth: .infinity)
            }
                .foregroundColor(.white)
                .padding()
                .background(Color.moruMePink)
                .cornerRadius(12)
        }
            .padding(.top, 34)
            .padding(.bottom, 23.5)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(27)
            .shadow(radius: 10)
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
        optionalSubMessage: nil,
        iconAsset: .photoLibraryIcon
    )
}
