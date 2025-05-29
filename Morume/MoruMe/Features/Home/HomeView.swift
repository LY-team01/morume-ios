//
//  HomeView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @State private var isNavigationActive = false

    var body: some View {
        NavigationStack {
            ZStack {
                MoruMeBackground()

                VStack {
                    Spacer()

                    Image(.topLogo)

                    if let resultPhoto = viewModel.resultPhoto {
                        VStack {
                            ResultCard(image: resultPhoto) {
                                Task {
                                    await viewModel.saveResultPhoto()
                                }
                            }
                            .padding(.horizontal, 18)
                            .padding(.bottom, 60)

                            WideButton(title: "次の写真を加工する") {
                                viewModel.resetState()
                            }
                        }
                    } else {
                        ImageUploadComponent(
                            selectedImage: $viewModel.selectedPhoto,
                            mainMessage: "集合写真をアップしよう",
                            iconAsset: .peopleIcon
                        )
                        .padding(.horizontal, 18)
                    }

                    Spacer()
                    Spacer()
                }
                .onChange(of: viewModel.selectedPhoto) {
                    isNavigationActive = viewModel.selectedPhoto != nil
                }
                .navigationDestination(isPresented: $isNavigationActive) {
                    if let photo = viewModel.selectedPhoto {
                        PhotoEditView(photo: photo, resultPhoto: $viewModel.resultPhoto)
                    }
                }
            }
        }
        .modifier(
            ToastOverlay(
                showToast: $viewModel.showErrorToast,
                icon: .errorIcon,
                message: "エラーが発生しました",
                type: .error
            )
        )
        .modifier(
            ToastOverlay(
                showToast: $viewModel.showSuccessToast,
                icon: .photoSavedIcon,
                message: "写真を保存しました",
                type: .success
            )
        )
    }
}

#Preview {
    HomeView()
}
