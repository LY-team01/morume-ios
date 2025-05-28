//
//  FaceMesh.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import Foundation

/// 顔のメッシュ
struct FaceMesh {
    /// 三角形メッシュ
    let triangles: [Triangle]

    /// ランドマーク点
    let points: [CGPoint]

    /// 初期化
    init(triangles: [Triangle], points: [CGPoint]) {
        self.triangles = triangles
        self.points = points
    }

    /// タプルからの変換イニシャライザ
    init(from tuple: ([Triangle], [CGPoint])) {
        self.triangles = tuple.0
        self.points = tuple.1
    }

    /// タプル表現への変換
    var asTuple: ([Triangle], [CGPoint]) {
        return (triangles, points)
    }

    /// 画像の四隅と辺の中点を生成する
    static func createExtraPoints(forImageSize size: CGSize) -> [CGPoint] {
        let imageWidth = size.width
        let imageHeight = size.height
        return [
            CGPoint(x: 0, y: 0),
            CGPoint(x: imageWidth, y: 0),
            CGPoint(x: imageWidth, y: imageHeight),
            CGPoint(x: 0, y: imageHeight),
            CGPoint(x: imageWidth / 2, y: 0),
            CGPoint(x: imageWidth, y: imageHeight / 2),
            CGPoint(x: imageWidth / 2, y: imageHeight),
            CGPoint(x: 0, y: imageHeight / 2)
        ]
    }
}
