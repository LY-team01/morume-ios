//
//  DetectedFace.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import Foundation
import SwiftUI

struct DetectedFace: Identifiable {
    let id = UUID()
    let faceRegion: CGRect
    let color: Color

    var user: User?
    var faceMesh: FaceMesh?

    init(faceRegion: CGRect, color: Color, user: User?, faceMesh: FaceMesh?) {
        self.faceRegion = faceRegion
        self.color = color
        self.user = user
        self.faceMesh = faceMesh
    }
}
