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
        GeometryReader { geometry in
            let commonFit = calculateFit(in: geometry.size)

            ZStack(alignment: .topLeading) {
                Image(uiImage: viewModel.editPhoto)
                    .resizable()
                    .scaledToFit()
                    .frame(width: commonFit.dispSize.width, height: commonFit.dispSize.height)
                    .offset(x: commonFit.xOffset, y: commonFit.yOffset)

                ForEach(viewModel.detectedFaces) { detectedFace in
                    let faceFit = calculateFit(in: geometry.size, faceRegion: detectedFace.faceRegion)
                    if let originalBox = faceFit.originalBox {
                        RoundedRectangle(cornerRadius: 7)
                            .stroke(detectedFace.color, lineWidth: 2)
                            .frame(width: originalBox.width * faceFit.scale, height: originalBox.height * faceFit.scale)
                            .offset(
                                x: originalBox.minX * faceFit.scale + faceFit.xOffset,
                                y: originalBox.minY * faceFit.scale + faceFit.yOffset
                            )
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
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

    // MARK: Fit Calculation
    // swiftlint:disable:next large_tuple
    private func calculateFit(in containerSize: CGSize, faceRegion: CGRect? = nil) -> (
        scale: CGFloat, dispSize: CGSize, xOffset: CGFloat, yOffset: CGFloat, originalBox: CGRect?
    ) {
        let imgSize = viewModel.editPhoto.size
        let scale = min(containerSize.width / imgSize.width, containerSize.height / imgSize.height)
        let dispSize = CGSize(width: imgSize.width * scale, height: imgSize.height * scale)
        let xOffset = (containerSize.width - dispSize.width) / 2
        let yOffset = (containerSize.height - dispSize.height) / 2

        var originalBox: CGRect?
        if let expandedBox = faceRegion {
            // Normalize the expanded box to 0…1
            let norm = CGRect(
                x: expandedBox.origin.x / imgSize.width,
                y: expandedBox.origin.y / imgSize.height,
                width: expandedBox.width / imgSize.width,
                height: expandedBox.height / imgSize.height
            )
            let expandRatio: CGFloat = 0.5
            let denom = 1 + expandRatio * 2
            let origW = norm.width / denom
            let origH = norm.height / denom
            let origX = norm.origin.x + norm.width * expandRatio / denom
            let origY = norm.origin.y + norm.height * expandRatio / denom
            originalBox = CGRect(
                x: origX * imgSize.width,
                y: origY * imgSize.height,
                width: origW * imgSize.width,
                height: origH * imgSize.height
            )
        }

        return (scale, dispSize, xOffset, yOffset, originalBox)
    }
}

#Preview {
    let photo = UIImage(resource: .sampleGroupPhoto)
    PhotoEditView(photo: photo)
}
