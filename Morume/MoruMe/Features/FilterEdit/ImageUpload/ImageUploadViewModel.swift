//
//  ImageUploadViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/30.
//

import Observation
import UIKit

@Observable
final class ImageUploadViewModel {
    var selectedPhoto: UIImage?
    var showErrorToast = false
}
