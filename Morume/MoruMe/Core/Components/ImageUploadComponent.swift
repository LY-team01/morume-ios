//
//  ImageUploadComponent.swift
//  MoruMe
//
//  Created by malab-nakazono on 2025/05/20.
//

import SwiftUI

struct SelectImageComponent: View {
    @Binding var selectedImage: UIImage?
    var body: some View {
        VStack(spacing: 8) {
            Image(.photoLibraryIcon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.moruMePink)
                .scaledToFit()
                .frame(maxWidth: .infinity)
            Text("写真ライブラリから選択")
                .foregroundStyle(Color.moruMePink)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
        .onTapGesture {
            LibraryPickerView(selectedImage: $selectedImage)
//            print("This is Library.") // debug
        }
    }
}

struct ImageUploadComponent: View {
    let mainMessage: String = "写真をアップロードしてください"
    @Binding var selectedImage: UIImage?
    var body: some View {
        VStack {
            Text(mainMessage)
                .foregroundColor(.moruMePink)
            if let viewImage = selectedImage {
                Image(uiImage: viewImage)
            }else {
                SelectImageComponent(selectedImage: $selectedImage)
            }
            Text("or")
                .foregroundColor(.moruMePink)
            Button("写真を撮る"){
//                CameraPickerView(selectedImage: $selectedImage)
                print("OK!") // debug
            }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.moruMePink)
                .cornerRadius(8)
        }
            .padding()
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 10)
    }
}

#Preview {
    ImageUploadComponent(
        selectedImage: .constant(nil)
    )
}
