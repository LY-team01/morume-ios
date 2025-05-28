//
//  FaceDetectionService.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/25.
//

import UIKit

protocol FaceDetectionService {
    func detectFaceRegions(in image: UIImage) throws -> [CGRect]
}
