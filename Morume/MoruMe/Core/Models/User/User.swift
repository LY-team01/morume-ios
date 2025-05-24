//
//  User.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    let nickname: String
    let avatarURL: URL?
    let filter: FilterParameters?
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case nickname
        case avatarURL = "avatarUrl"
        case filter
        case createdAt
        case updatedAt
    }
}
