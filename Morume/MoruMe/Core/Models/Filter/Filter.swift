//
//  Filter.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/17.
//

import Foundation

struct Filter: Codable {
    let userID: String
    let parameters: FilterParameters
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case parameters
        case createdAt
        case updatedAt
    }
}

struct FilterParameters: Codable {
    let brightness: Int
    let skin: Int
    let contour: Int
    let eye: Int
    let nose: Int
    let mouth: Int
}
