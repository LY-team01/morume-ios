//
//  ImageWarpUtility.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import Foundation
import UIKit

/// ワーピングに関するユーティリティクラス
final class ImageWarpUtility {
    /// 3点対応からアフィン変換行列を計算
    static func affineTransform(from src: [CGPoint], to dst: [CGPoint]) -> CGAffineTransform? {
        guard src.count == 3, dst.count == 3 else { return nil }
        let x0 = src[0].x
        let y0 = src[0].y
        let x1 = src[1].x
        let y1 = src[1].y
        let x2 = src[2].x
        let y2 = src[2].y
        let u0 = dst[0].x
        let v0 = dst[0].y
        let u1 = dst[1].x
        let v1 = dst[1].y
        let u2 = dst[2].x
        let v2 = dst[2].y
        let dx1 = x1 - x0
        let dy1 = y1 - y0
        let dx2 = x2 - x0
        let dy2 = y2 - y0
        let du1 = u1 - u0
        let dv1 = v1 - v0
        let du2 = u2 - u0
        let dv2 = v2 - v0
        let det = dx1 * dy2 - dx2 * dy1
        if abs(det) < 1e-6 { return nil }
        let a = (du1 * dy2 - du2 * dy1) / det
        let b = (du2 * dx1 - du1 * dx2) / det
        let c = u0 - a * x0 - b * y0
        let d = (dv1 * dy2 - dv2 * dy1) / det
        let e = (dv2 * dx1 - dv1 * dx2) / det
        let f = v0 - d * x0 - e * y0
        return CGAffineTransform(a: a, b: d, c: b, d: e, tx: c, ty: f)
    }

    /// CPUで三角形ごとにアフィン変換で画像をワーピング
    static func warpImageWithCPU(
        image: UIImage,
        srcPoints: [CGPoint],
        dstPoints: [CGPoint],
        triangles: [Triangle]
    ) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.setAllowsAntialiasing(false)
        ctx.setShouldAntialias(false)
        ctx.setBlendMode(.copy)
        ctx.interpolationQuality = .high
        ctx.translateBy(x: 0, y: image.size.height)
        ctx.scaleBy(x: 1, y: -1)
        for tri in triangles {
            let dstIdx = [tri.point1, tri.point2, tri.point3].map { pt in
                dstPoints.firstIndex(where: { abs($0.x - CGFloat(pt.x)) < 0.5 && abs($0.y - CGFloat(pt.y)) < 0.5 })
            }

            // すべてのインデックスが有効であることを確認
            guard let idx1 = dstIdx[0], let idx2 = dstIdx[1], let idx3 = dstIdx[2] else {
                print("[ImageWarpUtility] 三角形頂点のインデックスが見つかりません")
                continue
            }

            let validIndices = [idx1, idx2, idx3]
            let srcTriCG = validIndices.map { CGPoint(x: srcPoints[$0].x, y: image.size.height - srcPoints[$0].y) }
            let dstTriCG = validIndices.map { CGPoint(x: dstPoints[$0].x, y: image.size.height - dstPoints[$0].y) }

            let path = UIBezierPath()
            path.move(to: dstTriCG[0])
            path.addLine(to: dstTriCG[1])
            path.addLine(to: dstTriCG[2])
            path.close()
            ctx.saveGState()
            path.addClip()
            guard let tform = affineTransform(from: srcTriCG, to: dstTriCG) else {
                ctx.restoreGState()
                continue
            }
            ctx.concatenate(tform)
            if let cgimg = image.cgImage {
                ctx.draw(cgimg, in: CGRect(origin: .zero, size: image.size))
            }
            ctx.restoreGState()
        }
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
