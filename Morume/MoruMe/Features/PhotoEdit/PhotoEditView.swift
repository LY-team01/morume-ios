//
//  PhotoEditView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct PhotoEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: PhotoEditViewModel

    init(photo: UIImage) {
        self.viewModel = PhotoEditViewModel(originalImage: photo)
    }

    var body: some View {
        NavigationView {
            ZStack {
                MoruMeBackground()
                    .ignoresSafeArea()

                Color(uiColor: .systemGray6)

                VStack(spacing: 0) {
                    photoDisplayArea

                    userList
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                Text("写真を加工")
                    .foregroundStyle(.moruMePink)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.detectFaceLandmarks()
        }
    }

    // MARK: backButton
    private var backButton: some View {
        Button {
            viewModel.showResetAlert = true
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.moruMePink)
        }
        .alert("最初からやり直す", isPresented: $viewModel.showResetAlert) {
            Button(role: .cancel) {
            } label: {
                Text("いいえ")
            }
            Button("はい", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("編集内容が削除されます。よろしいですか？")
        }
    }

    // MARK: editArea
    private var photoDisplayArea: some View {
        Image(uiImage: viewModel.editPhoto)
            .resizable()
            .scaledToFit()
    }

    // MARK: userList
    private var userList: some View {
        List {
            ForEach(viewModel.detectedFaces) { detectedFace in
                Button {
                    print("pushed")
                } label: {
                    HStack(spacing: 18) {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(detectedFace.color)
                            .frame(width: 30, height: 30)

                        if let nickname = detectedFace.user?.nickname {
                            Text(nickname)
                        } else {
                            Text("ユーザー未選択")
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(Color(uiColor: .systemGray2))
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    let photo = UIImage(resource: .sampleGroupPhoto)
    PhotoEditView(photo: photo)
}
