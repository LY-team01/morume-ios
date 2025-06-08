//
//  VisionFaceDetectionService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import UIKit
import Vision

final class VisionFaceDetectionService: FaceDetectionService {
    /// Visionフレームワークで顔領域を検出
    func detectFaceRegions(in image: UIImage) throws -> [CGRect] {
        guard let cgImage = image.cgImage else {
            throw FaceDetectionError.cgImageConversionFailed
        }

        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            throw FaceDetectionError.visionFrameworkError
        }

        guard let observations = faceDetectionRequest.results else {
            return []
        }

        let faceRects = observations.map { observation in
            let normalizedBox = observation.boundingBox
            let expandRatio: CGFloat = 0.5
            let expandedWidth = normalizedBox.width * (1 + expandRatio * 2)
            let expandedHeight = normalizedBox.height * (1 + expandRatio * 2)
            let expandedX = max(0, normalizedBox.origin.x - normalizedBox.width * expandRatio)
            let expandedY = max(0, normalizedBox.origin.y - normalizedBox.height * expandRatio)

            let clampedWidth = min(expandedWidth, 1.0 - expandedX)
            let clampedHeight = min(expandedHeight, 1.0 - expandedY)

            let expandedBox = CGRect(
                x: expandedX,
                y: expandedY,
                width: clampedWidth,
                height: clampedHeight
            )

            return VNImageRectForNormalizedRect(
                expandedBox.flipped,
                Int(image.size.width),
                Int(image.size.height)
            )
        }

        return faceRects
    }
}

extension CGRect {
    var flipped: CGRect {
        return CGRect(
            x: origin.x,
            y: 1 - origin.y - height,
            width: width,
            height: height
        )
    }
}
