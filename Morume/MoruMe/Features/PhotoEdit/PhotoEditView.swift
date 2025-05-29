//
//  PhotoEditView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct PhotoEditView: View {
    @State private var viewModel: PhotoEditViewModel

    init(photo: UIImage) {
        self.viewModel = PhotoEditViewModel(originalImage: photo)
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .systemGray6)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    photoDisplayArea

                    userList
                }
            }
        }
        .task {
            await viewModel.detectFaceLandmarks()
        }
    }

    // MARK: editArea
    private var photoDisplayArea: some View {
        Image(uiImage: viewModel.editPhoto)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 350)
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
