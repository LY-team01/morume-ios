//
//  InitialView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/28.
//

import SwiftUI

struct InitialView: View {
    @Environment(ToastManager.self) private var toastManager
    @State private var viewModel = InitialViewModel()
    @State private var isNavigationActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                MoruMeBackground()

                VStack {
                    Spacer()

                    Image(.topLogo)

                    ImageUploadComponent(
                        selectedImage: $viewModel.selectedPhoto,
                        mainMessage: "まずは自撮りをアップロード！",
                        optionalSubMessage: "明るい場所で、顔がはっきり見えるように撮影しましょう",
                        iconAsset: .faceIcon
                    )
                    .padding(.horizontal, 18)

                    Spacer()
                    Spacer()
                }
                .onChange(of: viewModel.selectedPhoto) {
                    isNavigationActive = viewModel.selectedPhoto != nil
                }
                .navigationDestination(isPresented: $isNavigationActive) {
                    if let photo = viewModel.selectedPhoto {
                        InitialFilterMakeView(photo: photo)
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

#Preview {
    InitialView()
}
