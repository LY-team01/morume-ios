//
//  ContentView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/15.
//

import SwiftUI
import UIKit

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(.white)
        appearance.shadowColor = nil  // 上部の枠線（シャドウ）を消す
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(.homeIcon)
                        .renderingMode(.template)
                    Text("HOME")
                }
            FilterEditView()
                .tabItem {
                    Image(.filterIcon)
                        .renderingMode(.template)
                    Text("FILTER")
                }
        }
        .tint(.morumePink)
    }
}

#Preview {
    ContentView()
}
