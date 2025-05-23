//
//  ImageUploadComponent.swift
//  MoruMe
//
//  Created by malab-nakazono on 2025/05/20.
//

import SwiftUI

struct SelectImageComponent: View {
    @Binding var selectedImage: UIImage?
    @Binding var showLibraryPicker: Bool
    var body: some View {
        Button {
            showLibraryPicker = true
        } label: {
            VStack(spacing: 8) {
                Image(.photoLibraryIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.moruMePink)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                Text("写真ライブラリから選択")
                    .font(.system(size: 21))
                    .foregroundStyle(Color.moruMePink)
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct ImageUploadComponent: View {
    @Binding var selectedImage: UIImage?
    var mainMessage: String = "写真をアップロードしてください"
    var optionalSubMessage: String? = nil
    @State private var showCameraPicker = false
    @State var showLibraryPicker = false
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
            SelectImageComponent(selectedImage: $selectedImage, showLibraryPicker: $showLibraryPicker)
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
                .cornerRadius(8)
        }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
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
        selectedImage: .constant(nil)
    )
}
