//
//  HomeView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct HomeView: View {
    @Environment(ToastManager.self) private var toastManager
    @State private var viewModel = HomeViewModel()

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
                    if viewModel.selectedPhoto != nil {
                        Task {
                            await viewModel.validateSelectedPhoto()
                        }
                    }
                }
                .navigationDestination(isPresented: $viewModel.shouldNavigate) {
                    if let photo = viewModel.selectedPhoto {
                        PhotoEditView(photo: photo, resultPhoto: $viewModel.resultPhoto)
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
    HomeView()
}
