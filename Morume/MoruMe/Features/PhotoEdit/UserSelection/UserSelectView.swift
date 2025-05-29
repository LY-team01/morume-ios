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
                    .ignoresSafeArea(edges: .bottom)

                userList
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backButton
            }
            ToolbarItem(placement: .principal) {
                Text("ユーザー選択")
                    .foregroundStyle(.moruMePink)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            do {
                try await viewModel.fetchAllUsers()
            } catch {
                print("Error fetching users: \(error)")
            }
        }
    }

    // MARK: backButton
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .foregroundStyle(.moruMePink)
        }
    }

    // MARK: userList
    private var userList: some View {
        List {
            // リスト
        }
    }
}

#Preview {
    @Previewable @State var selectedUser: User?
    UserSelectView(selectedUser: $selectedUser)
}
