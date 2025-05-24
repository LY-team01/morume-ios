//
//  CreateUserRequestBody.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/24.
//

import Foundation

struct CreateUserRequestBody: Encodable {
    let nickname: String
    let avatarURL: URL?
    let filter: FilterParameters
}
