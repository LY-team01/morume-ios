//
//  FaceDetection.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import Foundation

/// 顔の検出結果
struct FaceDetection {
    let boundingBox: CGRect
    let confidence: Float
}
