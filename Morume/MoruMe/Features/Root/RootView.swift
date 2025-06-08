//
//  RootView.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import SwiftUI

struct RootView: View {
    @State private var viewModel = RootViewModel()

    var body: some View {
        Group {
            switch viewModel.appState {
            case .loading:
                LoadingView()
            case .error:
                LoadingView(
                    isError: true,
                    onRetry: {
                        Task {
                            await viewModel.retry()
                        }
                    }
                )
            case .initial:
                InitialView()
            case .main:
                ContentView()
            }
        }
        .onAppear {
            Task {
                await viewModel.checkInitialState()
            }
        }
        .modifier(
            ToastOverlay()
        )
    }
}

#Preview {
    RootView()
}
