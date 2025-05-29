//
//  LoadingView.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import SwiftUI

struct LoadingView: View {
    let isError: Bool
    let onRetry: (() -> Void)?

    @State private var showErrorToast = false

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
        .modifier(
            ToastOverlay(
                showToast: $showErrorToast,
                icon: .errorIcon,
                message: "ネットワークエラーが発生しました",
                type: .error
            )
        )
        .onAppear {
            if isError {
                showErrorToast = true
            }
        }
        .onChange(of: isError) { _, newValue in
            if newValue {
                showErrorToast = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
