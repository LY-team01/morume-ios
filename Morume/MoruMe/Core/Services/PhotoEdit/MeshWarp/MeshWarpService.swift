//
//  MeshWarpService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import UIKit

final class MeshWarpService {
    private let metalRenderer: MetalWarpRenderer? = MetalWarpRenderer()

    /// 特定のランドマークを拡大・縮小する変換を適用
    private func applyScalingTransformation(
        editingPoints: [CGPoint],
        originalPoints: [CGPoint],
        indices: [Int],
        scale: CGFloat
    ) -> [CGPoint] {
        // 編集中の点のコピーを作成
        var newPoints = editingPoints.map { $0 }

        // 指定されたランドマークの重心を計算（元の点を使用）
        let center =
            indices
            .map { originalPoints[$0] }
            .reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        let centerPoint = CGPoint(
            x: center.x / CGFloat(indices.count),
            y: center.y / CGFloat(indices.count)
        )

        // 指定されたランドマーク点を重心から外側にscale倍拡大
        for idx in indices {
            let original = originalPoints[idx]  // 必ず元の点を使用
            let dx = original.x - centerPoint.x
            let dy = original.y - centerPoint.y
            newPoints[idx] = CGPoint(
                x: centerPoint.x + dx * scale,
                y: centerPoint.y + dy * scale
            )
        }

        return newPoints
    }

    /// 左目を拡大・縮小する変換を適用
    func applyLeftEyeScalingTransformation(editingPoints: [CGPoint], originalPoints: [CGPoint], scale: CGFloat)
        -> [CGPoint]
    {
        applyScalingTransformation(
            editingPoints: editingPoints,
            originalPoints: originalPoints,
            indices: FaceIndices.leftEye,
            scale: scale
        )
    }

    /// 右目を拡大・縮小する変換を適用
    func applyRightEyeScalingTransformation(editingPoints: [CGPoint], originalPoints: [CGPoint], scale: CGFloat)
        -> [CGPoint]
    {
        applyScalingTransformation(
            editingPoints: editingPoints,
            originalPoints: originalPoints,
            indices: FaceIndices.rightEye,
            scale: scale
        )
    }

    /// 両目を拡大・縮小する変換を適用
    func applyEyesScalingTransformation(editingPoints: [CGPoint], originalPoints: [CGPoint], scale: CGFloat)
        -> [CGPoint]
    {
        let points = applyLeftEyeScalingTransformation(
            editingPoints: editingPoints,
            originalPoints: originalPoints,
            scale: scale
        )
        return applyRightEyeScalingTransformation(editingPoints: points, originalPoints: originalPoints, scale: scale)
    }

    /// 鼻を拡大・縮小する変換を適用
    func applyNoseScalingTransformation(editingPoints: [CGPoint], originalPoints: [CGPoint], scale: CGFloat)
        -> [CGPoint]
    {
        applyScalingTransformation(
            editingPoints: editingPoints,
            originalPoints: originalPoints,
            indices: FaceIndices.nose,
            scale: scale
        )
    }

    /// 口を拡大・縮小する変換を適用
    func applyMouthScalingTransformation(editingPoints: [CGPoint], originalPoints: [CGPoint], scale: CGFloat)
        -> [CGPoint]
    {
        applyScalingTransformation(
            editingPoints: editingPoints,
            originalPoints: originalPoints,
            indices: FaceIndices.mouth,
            scale: scale
        )
    }

    /// 画像にメッシュワーピングを適用
    func warpImage(image: UIImage, srcPoints: [CGPoint], dstPoints: [CGPoint], triangles: [Triangle]) -> UIImage? {
        // Metalでワーピング（可能な場合）
        if let metalRenderer = metalRenderer {
            if let warpedImage = metalRenderer.warp(
                image: image,
                srcPoints: srcPoints,
                dstPoints: dstPoints,
                triangles: triangles
            ) {
                return warpedImage
            }
        }

        // Metal失敗時はCPU版を使用
        return ImageWarpUtility.warpImageWithCPU(
            image: image,
            srcPoints: srcPoints,
            dstPoints: dstPoints,
            triangles: triangles
        )
    }
}
