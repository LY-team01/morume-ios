//
//  UserRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import Foundation

protocol UserRepository {
    /// ユーザーを登録
    func addUser(nickname: String, avatarURL: URL?, filterParameters: FilterParameters) async throws -> User
    /// 自分のユーザー情報を取得
    func fetchMyUser() async throws -> User
    /// 全ユーザー情報を取得
    func fetchUsers() async throws -> [User]
}
