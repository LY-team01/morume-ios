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

struct FilterParameters: Codable, Equatable, Hashable {
    var brightness: Int = 0
    var skin: Int = 0
    var contour: Int = 0
    var eye: Int = 0
    var nose: Int = 0
    var mouth: Int = 0

    func toScale() -> [String: Float] {
        return [
            "brightness": 1.0 + 0.001 * Float(brightness),
            "skin": 1.0 + 0.001 * Float(skin),
            "contour": 1.0 + 0.001 * Float(contour),
            "eye": 1.0 + 0.001 * Float(eye),
            "nose": 1.0 + 0.001 * Float(nose),
            "mouth": 1.0 + 0.001 * Float(mouth)
        ]
    }
}
