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
    @State private var viewModel = UserSelectViewModel()

    init(selectedUser: Binding<User?>) {
        self._selectedUser = selectedUser
        UIRefreshControl.appearance().tintColor = UIColor(Color.moruMePink)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                MoruMeBackground()
                    .ignoresSafeArea()

                Color(uiColor: .systemGray6)
                    .ignoresSafeArea(edges: .bottom)

                if viewModel.isProcessing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .moruMePink))
                        .scaleEffect(1.5)
                } else {
                    userList
                }
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
            ForEach($viewModel.allUsers) { $user in
                Button {
                    selectedUser = selectedUser == user ? nil : user
                    dismiss()
                } label: {
                    HStack {
                        Text(user.nickname)
                            .foregroundStyle(Color(uiColor: .systemGray2))
                        Spacer()
                        if user == selectedUser {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.moruMePink)
                        }
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .refreshable {
            do {
                try await viewModel.refreshUsers()
            } catch {
                print("Error refreshing users: \(error)")
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedUser: User?
    UserSelectView(selectedUser: $selectedUser)
}
