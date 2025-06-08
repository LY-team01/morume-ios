//
//  FilterEditView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import SwiftUI

struct FilterEditView: View {
    @Environment(ToastManager.self) private var toastManager
    @Environment(\.dismiss) private var dismiss
    @FocusState var textFieldFocus: Bool
    @State private var viewModel: FilterEditViewModel

    init(photo: UIImage) {
        self.viewModel = FilterEditViewModel(originalImage: photo)
    }

    var body: some View {
        VStack {
            ZStack {
                MoruMeBackground()

                editArea

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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                Text("フィルター編集")
                    .foregroundStyle(.moruMePink)
            }
            ToolbarItem(placement: .topBarTrailing) {
                saveButton
            }
        }
        .task {
            await viewModel.detectFaceLandmarks()
            do {
                try await viewModel.restoreParameters()
            } catch {
                // Handle error if needed
            }
            // 少し時間を置いて顔検出が完了するのを待ってからviewModelを更新する
            try? await Task.sleep(for: .seconds(1))
            if viewModel.shouldBackToInitialView {
                withAnimation {
                    // Handle navigation back to initial view if needed
                }
                dismiss()
            }
            viewModel.applyFilterParameters()
        }
        .onChange(of: viewModel.filterParameters) {
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

    // MARK: saveButton
    private var saveButton: some View {
        Button {
            Task {
                do {
                    try await viewModel.createFilter()
                    viewModel.toastEvent = ToastState(icon: .photoSavedIcon, message: "フィルターを保存しました", type: .success)
                } catch {
                    let message = (error as? LocalizedError)?.errorDescription ?? "エラーが発生しました"
                    viewModel.toastEvent = ToastState(icon: .errorIcon, message: message, type: .error)
                }
            }
        } label: {
            Text("保存")
                .foregroundStyle(viewModel.nickname.isEmpty ? Color(UIColor.systemGray2) : .morumeGreen)
        }
        .disabled(viewModel.nickname.isEmpty)
    }

    // MARK: editArea
    private var editArea: some View {
        ScrollView {
            VStack(spacing: 25) {
                if let photo = viewModel.editPhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .clipped()
                }

                TextField("ニックネーム", text: $viewModel.nickname)
                    .textFieldStyle(WithUnderBarTextFieldStyle())
                    .padding(.horizontal, 44)
                    .focused($textFieldFocus)

                VStack(spacing: 0) {
                    FilterSlider(label: "目", value: $viewModel.filterParameters.eye)
                    FilterSlider(label: "鼻", value: $viewModel.filterParameters.nose)
                    FilterSlider(label: "口", value: $viewModel.filterParameters.mouth)
                }
                .padding(.horizontal, 40)
            }
        }
        // FIXME: なぜかこれがないと画像がナビゲーションバーに被ってしまう。
        .padding(.top, 0.5)
        .onTapGesture {
            textFieldFocus = false
        }
        .scrollBounceBehavior(.basedOnSize)
        .background {
            Color.white
                .shadow(color: .black.opacity(0.25), radius: 18, x: 4, y: 4)
        }
    }
}

#Preview {
    FilterEditView(photo: UIImage(resource: .sampleSelfie))
}
