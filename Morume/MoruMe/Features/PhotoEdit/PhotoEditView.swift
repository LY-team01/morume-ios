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
                    .ignoresSafeArea(edges: .bottom)

                VStack(spacing: 0) {
                    photoDisplayArea

                    if viewModel.originalPhoto != viewModel.editPhoto {
                        resetButton
                    }

                    userList
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
            viewModel.applyFilterParameters()
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
    // FIXME: 横長画像の時、GeometryReader内上部に余白ができてしまう
    private var photoDisplayArea: some View {
        GeometryReader { geometry in
            let commonFit = calculateFit(in: geometry.size)
            let imgSize = viewModel.displayedPhoto.size

            ZStack {
                Image(uiImage: viewModel.displayedPhoto)
                    .resizable()
                    .scaledToFit()
                    .frame(width: commonFit.dispSize.width, height: commonFit.dispSize.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)

                ForEach(viewModel.detectedFaces) { detectedFace in
                    if let originalBox = calculateFit(in: geometry.size, faceRegion: detectedFace.faceRegion)
                        .originalBox
                    {
                        let dx = (originalBox.midX - imgSize.width / 2) * commonFit.scale
                        let dy = (originalBox.midY - imgSize.height / 2) * commonFit.scale

                        RoundedRectangle(cornerRadius: 7)
                            .stroke(detectedFace.color, lineWidth: 2)
                            .frame(
                                width: originalBox.width * commonFit.scale,
                                height: originalBox.height * commonFit.scale
                            )
                            .position(x: geometry.size.width / 2 + dx, y: geometry.size.height / 2 + dy)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    // MARK: userList
    private var userList: some View {
        List($viewModel.detectedFaces) { $detectedFace in
            NavigationLink(destination: UserSelectView(selectedUser: $detectedFace.user)) {
                HStack(spacing: 18) {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(detectedFace.color)
                        .frame(width: 30, height: 30)
                    Text(detectedFace.user?.nickname ?? "ユーザー未選択")
                    Spacer()
                }
                .foregroundStyle(Color(uiColor: .systemGray2))
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollContentBackground(.hidden)
    }

    // MARK: resetButton
    private var resetButton: some View {
        Button {
        } label: {
            HStack {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 20))
                Text("元の写真を確認")
                    .font(.system(size: 17))
            }
        }
        .buttonStyle(
            SBButtonStyle(tintColor: .moruMePink, onTouchDown: {
                viewModel.showOriginalPhoto = true
            }, onTouchUp: {
                viewModel.showOriginalPhoto = false
            })
        )
    }

    // MARK: Fit Calculation
    // swiftlint:disable:next large_tuple
    private func calculateFit(in containerSize: CGSize, faceRegion: CGRect? = nil) -> (
        scale: CGFloat, dispSize: CGSize, xOffset: CGFloat, yOffset: CGFloat, originalBox: CGRect?
    ) {
        let imgSize = viewModel.displayedPhoto.size
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

// MARK: SBButtonStyle
private struct SBButtonStyle: ButtonStyle {
    let tintColor: Color
    let pressedColor: Color = Color(uiColor: .systemGray3)
    let onTouchDown: () -> Void
    let onTouchUp: () -> Void

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) {
                configuration.isPressed ? onTouchDown() : onTouchUp()
            }
            .foregroundStyle(configuration.isPressed ? pressedColor : tintColor)
            .sensoryFeedback(.selection, trigger: configuration.isPressed)
    }
}

#Preview {
    let photo = UIImage(resource: .sampleGroupPhoto)
    PhotoEditView(photo: photo)
}
