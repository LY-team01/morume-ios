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
                        ResultCard(image: resultPhoto) {
                            Task {
                                await viewModel.saveResultPhoto()
                            }
                        }
                        .padding(.horizontal, 18)
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
                    if viewModel.selectedPhoto != nil {
                        FilterEditView()
                    }
                }
            }
        }
        .modifier(
            ToastOverlay(showToast: $viewModel.showErrorToast, icon: .errorIcon, message: "エラーが発生しました", type: .error)
        )
        .modifier(
            ToastOverlay(
                showToast: $viewModel.showErrorToast,
                icon: .checkmarkCircleIcon,
                message: "フィルターを作成しました",
                type: .success
            )
        )
    }
}

#Preview {
    HomeView()
}
