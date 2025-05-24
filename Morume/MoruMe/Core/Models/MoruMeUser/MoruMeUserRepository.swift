//
//  MoruMeUserRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import Foundation

protocol MoruMeUserRepository {
    /// ユーザーを登録
    func addUser(nickname: String, avatarURL: URL?) async throws -> MoruMeUser
    /// 自分のユーザー情報を取得
    func fetchMyUser() async throws -> MoruMeUser
    /// 全ユーザー情報を取得
    func fetchUsers() async throws -> [MoruMeUser]
}
