//
//  UserSelectView.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import SwiftUI

struct UserSelectView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedUser: User?

    var body: some View {
        NavigationView {
            ZStack {
                MoruMeBackground()
                    .ignoresSafeArea()

                Color(uiColor: .systemGray6)

                userList
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ユーザー選択")
                    .foregroundStyle(.moruMePink)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            // 全ユーザーを取得
        }
    }

    private var userList: some View {
        List {
            // リスト
        }
    }
}

#Preview {
    @Previewable @State var selectedUser: User? = nil
    UserSelectView(selectedUser: $selectedUser)
}
