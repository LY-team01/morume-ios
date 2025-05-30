//
//  ImageUploadView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import SwiftUI

struct ImageUploadView: View {
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
                        FilterEditView(photo: photo, showInitialViewErrorToast: $viewModel.showErrorToast)
                    }
                }
            }
        }
        .modifier(
            ToastOverlay(showToast: $viewModel.showErrorToast, icon: .errorIcon, message: "エラーが発生しました", type: .error)
        )
    }
}
