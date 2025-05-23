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
        Button(action: {
//            LibraryPickerView(selectedImage: $selectedImage)
            print("This is Library.") // debug
        }) {
            VStack(spacing: 8) {
                Image(.photoLibraryIcon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.moruMePink)
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                Text("写真ライブラリから選択")
                    .foregroundStyle(Color.moruMePink)
                    .font(.system(size:21))
            }
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(20)
    }
}

struct ImageUploadComponent: View {
    let mainMessage: String = "写真をアップロードしてください"
    @Binding var selectedImage: UIImage?
    var body: some View {
        VStack {
            Text(mainMessage)
                .foregroundColor(.moruMePink)
                .font(.system(size: 21))
            if let viewImage = selectedImage {
                Image(uiImage: viewImage)
            }else {
                SelectImageComponent(selectedImage: $selectedImage)
            }
            Text("or")
                .foregroundColor(.moruMePink)
                .font(.system(size: 21))
            Button(action: {
                //                CameraPickerView(selectedImage: $selectedImage)
                print("OK!") // debug
            })
            {
                Text("写真を撮る")
                    .font(.system(size: 21))
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
    }
}

#Preview {
    ImageUploadComponent(
        selectedImage: .constant(nil)
    )
}
