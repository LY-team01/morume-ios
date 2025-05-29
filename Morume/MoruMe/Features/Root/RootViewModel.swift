//
//  RootViewModel.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import Observation
import SwiftUI

@Observable
class RootViewModel {
    enum AppState {
        case loading
        case error
        case initial
        case main
    }

    var appState: AppState = .loading
    private let filterRepository: MoruMeAPIFilterRepository

    init() {
        self.filterRepository = MoruMeAPIFilterRepository()
    }

    func checkInitialState() async {
        do {
            // 自分のフィルターを取得してみる
            _ = try await filterRepository.fetchMyFilter()

            // フィルターが存在する場合、メイン画面へ
            await MainActor.run {
                appState = .main
            }
        } catch APIError.noData {
            // フィルターが存在しない場合
            await MainActor.run {
                appState = .initial
            }
        } catch {
            // その他のエラーはエラー状態へ
            await MainActor.run {
                appState = .error
            }
        }
    }

    func retry() async {
        await MainActor.run {
            appState = .loading
        }
        await checkInitialState()
    }
}
