//
//  FaceLandmarkService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import UIKit

protocol FaceLandmarkService {
    func detectLandmarks(on faceImage: UIImage, actualCropRect: CGRect) async throws -> FaceMesh?
}
