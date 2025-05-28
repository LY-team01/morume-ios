//
//  MediaPipeFaceLandmarkService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import DelaunayTriangulation
import MediaPipeTasksVision
import UIKit

final class MediaPipeFaceLandmarkService: FaceLandmarkService {
    /// MediaPipeを使用して顔のランドマークを検出
    func detectLandmarks(on faceImage: UIImage, actualCropRect: CGRect) async throws -> FaceMesh? {
        // MediaPipeのモデルパスを取得
        let modelPath = Bundle.main.path(forResource: "face_landmarker", ofType: "task")!

        // 初回処理用のオプション設定
        let options = FaceLandmarkerOptions()
        options.numFaces = 1  // 切り取った顔画像には1つの顔のみ
        options.baseOptions.modelAssetPath = modelPath
        options.runningMode = .image

        // MediaPipe画像に変換
        let mpImage = try MPImage(uiImage: faceImage)
        let landmarker = try FaceLandmarker(options: options)
        let result = try landmarker.detect(image: mpImage)

        // ランドマークが検出されたか確認
        if let landmarkList = result.faceLandmarks.first {
            return processFaceLandmarks(
                landmarkList: landmarkList,
                faceImageSize: faceImage.size,
                actualCropRect: actualCropRect
            )
        }
        return nil
    }

    /// 検出されたランドマークを処理してFaceMeshを作成
    private func processFaceLandmarks(
        landmarkList: [NormalizedLandmark],
        faceImageSize: CGSize,
        actualCropRect: CGRect
    ) -> FaceMesh {
        // ランドマーク点を元画像の座標系に変換
        let allPoints: [CGPoint] = landmarkList.map { landmark in
            // MediaPipeの正規化された座標を顔画像の座標に変換
            let faceX = CGFloat(landmark.x) * faceImageSize.width
            let faceY = CGFloat(landmark.y) * faceImageSize.height

            // 顔画像の座標を元画像の座標に変換
            let originalX = actualCropRect.origin.x + faceX
            let originalY = actualCropRect.origin.y + faceY

            return CGPoint(x: originalX, y: originalY)
        }

        // ドロネー三角形分割
        let delaunayPoints = allPoints.map { DelaunayTriangulation.Point(x: Double($0.x), y: Double($0.y)) }
        let triangles = triangulate(delaunayPoints)

        // FaceMeshのインスタンスを作成
        return FaceMesh(triangles: triangles, points: allPoints)
    }
}
