//
//  ContentView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/15.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(ToastManager.self) private var toastManager
    @Binding var hasFilterSaveSucceeded: Bool

    init(hasFilterSaveSucceeded: Binding<Bool> = .constant(false)) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.white)
        appearance.shadowColor = nil  // 上部の枠線（シャドウ）を消す
        appearance.stackedLayoutAppearance.selected.iconColor = .moruMePink
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.moruMePink
        ]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        self._hasFilterSaveSucceeded = hasFilterSaveSucceeded
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(.homeIcon)
                        .renderingMode(.template)
                    Text("HOME")
                }
            ImageUploadView()
                .tabItem {
                    Image(.filterIcon)
                        .renderingMode(.template)
                    Text("FILTER")
                }
        }
        .onChange(of: hasFilterSaveSucceeded) {
            if hasFilterSaveSucceeded {
                toastManager.show(icon: .checkmarkCircleIcon, message: "フィルターを作成しました", type: .success)
            }
        }
    }
}

#Preview {
    ContentView()
}
