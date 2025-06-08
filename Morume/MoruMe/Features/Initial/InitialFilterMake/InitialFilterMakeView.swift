//
//  InitialFilterMakeView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct InitialFilterMakeView: View {
    @Environment(ToastManager.self) private var toastManager
    @Environment(\.dismiss) private var dismiss
    @FocusState var textFieldFocus: Bool
    @State private var viewModel: InitialFilterMakeViewModel

    init(photo: UIImage) {
        self.viewModel = InitialFilterMakeViewModel(originalImage: photo)
    }
    var body: some View {
        NavigationStack {
            ZStack {
                MoruMeBackground()

                editArea
                    .padding(18)

                if viewModel.isProcessing {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: viewModel.toastEvent) {
            guard let event = viewModel.toastEvent else { return }
            toastManager.show(icon: event.icon, message: event.message, type: event.type)
            viewModel.toastEvent = nil
        }
        .fullScreenCover(isPresented: $viewModel.goToNextView) {
            ContentView()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                Text("フィルターを作成")
                    .foregroundStyle(.moruMePink)
            }
        }
        .task {
            await viewModel.detectFaceLandmarks()
            // 少し時間を置いて顔検出が完了するのを待ってからviewModelを更新する
            try? await Task.sleep(for: .seconds(1))
            if viewModel.shouldBackToInitialView {
                withAnimation {
                    dismiss()
                }
            }
        }
    }

    /// 写真編集エリア
    private var editArea: some View {
        ScrollView {
            VStack(spacing: 25) {
                if let photo = viewModel.editPhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 350)
                        .clipped()
                }

                TextField("ニックネーム", text: $viewModel.nickname)
                    .textFieldStyle(WithUnderBarTextFieldStyle())
                    .padding(.horizontal, 24)
                    .focused($textFieldFocus)

                VStack(spacing: 0) {
                    FilterSlider(label: "目", value: $viewModel.filterParameters.eye)
                    FilterSlider(label: "鼻", value: $viewModel.filterParameters.nose)
                    FilterSlider(label: "口", value: $viewModel.filterParameters.mouth)
                }
                .padding(.horizontal, 20)

                WideButton(title: "フィルターを作成") {
                    Task {
                        do {
                            try await viewModel.createFilter()
                            viewModel.goToNextView = true
                        } catch {
                            viewModel.toastEvent = ToastState(icon: .errorIcon, message: "エラーが発生しました", type: .error)
                        }
                    }
                }
                .padding(.bottom, 26)
                .disabled(viewModel.nickname.isEmpty)
            }
        }
        .onTapGesture {
            textFieldFocus = false
        }
        .scrollBounceBehavior(.basedOnSize)
        .background {
            Color.white
                .shadow(color: .black.opacity(0.25), radius: 18, x: 4, y: 4)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    /// 戻るボタン
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
}

struct WithUnderBarTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(spacing: 3) {
            configuration
            Divider()
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    let photo = UIImage(resource: .sampleSelfie)
    InitialFilterMakeView(photo: photo)
}
