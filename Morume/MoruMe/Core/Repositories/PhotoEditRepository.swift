//
//  PhotoEditRepository.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import UIKit

/// 顔処理の全体を調整するリポジトリ
final class PhotoEditRepository {
    private let faceDetectionService: FaceDetectionService
    private let faceLandmarkService: FaceLandmarkService
    private let meshWarpService: MeshWarpService

    /// 元写真
    let originalPhoto: UIImage
    /// 検出された顔の画像内の領域
    var detectedFaceRegions: [CGRect] = []
    /// 検出された顔のメッシュ
    var detectedFaceMeshes: [FaceMesh] = []

    init(originalPhoto: UIImage) {
        self.originalPhoto = originalPhoto
        self.faceDetectionService = VisionFaceDetectionService()
        self.faceLandmarkService = MediaPipeFaceLandmarkService()
        self.meshWarpService = MeshWarpService()
    }

    /// 顔の検出からランドマーク抽出までの処理を実行
    func detectFaceAndLandmarks() async throws {
        let faceRegions = try faceDetectionService.detectFaceRegions(in: originalPhoto)

        if faceRegions.isEmpty {
            throw NSError(
                domain: "FaceProcessingRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "顔が検出されませんでした"]
            )
        }

        detectedFaceRegions = []
        detectedFaceMeshes = []
        for faceRegion in faceRegions {
            guard let croppedFaceImage = originalPhoto.cropped(to: faceRegion) else {
                print("顔の切り抜きに失敗: \(faceRegion)")
                continue
            }
            if let faceMesh = try await faceLandmarkService.detectLandmarks(
                on: croppedFaceImage,
                actualCropRect: faceRegion
            ) {
                detectedFaceRegions.append(faceRegion)
                detectedFaceMeshes.append(faceMesh)
            }
        }
    }

    /// 全ての変形を適用して新しいメッシュと画像を生成
    func applyTransformations(
        faceIndex: Int = 0,
        eyeScale: CGFloat,
        noseScale: CGFloat,
        mouthScale: CGFloat
    ) throws -> UIImage {
        guard faceIndex >= 0, faceIndex < detectedFaceMeshes.count else {
            throw NSError(
                domain: "PhotoEditRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "無効な顔インデックス"]
            )
        }
        // 元の点をコピー
        let originalPoints = detectedFaceMeshes[faceIndex].points
        var points = originalPoints

        // 変形を順番に適用（点の座標を累積的に変更）
        if eyeScale != 1 {
            print("目の変形を適用します")
            points = meshWarpService.applyEyesScalingTransformation(
                editingPoints: points,
                originalPoints: originalPoints,
                scale: eyeScale
            )
        }

        if noseScale != 1 {
            print("鼻の変形を適用します")
            points = meshWarpService.applyNoseScalingTransformation(
                editingPoints: points,
                originalPoints: originalPoints,
                scale: noseScale
            )
        }

        if mouthScale != 1 {
            print("口の変形を適用します")
            points = meshWarpService.applyMouthScalingTransformation(
                editingPoints: points,
                originalPoints: originalPoints,
                scale: mouthScale
            )
        }

        // 画像の四隅と辺の中点を追加
        let extraPoints = FaceMesh.createExtraPoints(forImageSize: originalPhoto.size)

        // 元のランドマーク点に追加点を結合
        var augmentedSrc = originalPoints
        var augmentedDst = points
        augmentedSrc.append(contentsOf: extraPoints)
        augmentedDst.append(contentsOf: extraPoints)

        // Delaunay三角形分割
        let delaunayPoints = augmentedDst.map { DelaunayTriangulation.Point(x: Double($0.x), y: Double($0.y)) }
        let triangles = triangulate(delaunayPoints)

        // ワーピングで画像を変形
        guard
            let warpedImage = meshWarpService.warpImage(
                image: originalPhoto,
                srcPoints: augmentedSrc,
                dstPoints: augmentedDst,
                triangles: triangles
            )
        else {
            throw NSError(
                domain: "PhotoEditRepository",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "メッシュワーピングに失敗しました"]
            )
        }

        return warpedImage
    }
}

extension UIImage {
    /// 元画像のピクセル座標 (point) で指定した領域を切り抜いて返す
    func cropped(to rect: CGRect) -> UIImage? {
        // CGImage を取得して cropping(to:) で切り抜き
        guard let cgImage = self.cgImage?.cropping(to: rect) else {
            return nil
        }
        // 元のスケール・向きを維持して UIImage に戻す
        return UIImage(
            cgImage: cgImage,
            scale: self.scale,
            orientation: self.imageOrientation
        )
    }
}
