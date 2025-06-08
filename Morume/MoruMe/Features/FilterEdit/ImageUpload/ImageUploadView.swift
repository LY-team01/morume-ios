//
//  ImageUploadView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import SwiftUI

struct ImageUploadView: View {
    @Environment(ToastManager.self) private var toastManager
    @State private var viewModel = ImageUploadViewModel()
    @State private var isNavigationActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                MoruMeBackground()

                VStack {
                    ImageUploadComponent(
                        selectedImage: $viewModel.selectedPhoto,
                        mainMessage: "自撮りをアップロード！",
                        optionalSubMessage: "明るい場所で、顔がはっきり見えるように撮影しましょう",
                        iconAsset: .faceIcon
                    )
                    .padding(.horizontal, 18)
                }
                .onChange(of: viewModel.selectedPhoto) {
                    isNavigationActive = viewModel.selectedPhoto != nil
                }
                .navigationDestination(isPresented: $isNavigationActive) {
                    if let photo = viewModel.selectedPhoto {
                        FilterEditView(photo: photo)
                    }
                }
            }
        }
        .onChange(of: viewModel.toastEvent) {
            guard let event = viewModel.toastEvent else { return }
            toastManager.show(icon: event.icon, message: event.message, type: event.type)
            viewModel.toastEvent = nil
        }
    }
}
