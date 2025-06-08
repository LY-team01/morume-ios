//
//  LoadingView.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import SwiftUI

struct LoadingView: View {
    @Environment(ToastManager.self) private var toastManager
    let isError: Bool
    let onRetry: (() -> Void)?

    @State private var didShowError = false

    init(isError: Bool = false, onRetry: (() -> Void)? = nil) {
        self.isError = isError
        self.onRetry = onRetry
    }

    var body: some View {
        ZStack {
            MoruMeBackground()

            VStack {
                Image(.topLogo)
                    .padding(.bottom, 50)

                if isError {
                    // エラー状態
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundStyle(.moruMePink)

                        Text("エラーが発生しました")
                            .font(.headline)
                            .foregroundStyle(.moruMePink)

                        if let onRetry = onRetry {
                            WideButton(
                                title: "再試行",
                                action: onRetry
                            )
                            .padding(.horizontal, 50)
                        }
                    }
                } else {
                    // ローディング状態
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .moruMePink))
                            .scaleEffect(1.5)

                        Text("読み込み中...")
                            .foregroundStyle(.moruMePink)
                            .padding(.top, 20)
                    }
                }
            }
        }
        .onAppear {
            if isError && !didShowError {
                toastManager.show(icon: .errorIcon, message: "ネットワークエラーが発生しました", type: .error)
                didShowError = true
            }
        }
        .onChange(of: isError) {
            if isError {
                toastManager.show(icon: .errorIcon, message: "ネットワークエラーが発生しました", type: .error)
            }
        }
    }
}

#Preview {
    LoadingView()
}
