//
//  HomeViewModel.swift
//  MoruMe
//
//  Created by System on 2025/05/29.
//

import Observation
import UIKit

@Observable
final class HomeViewModel {
    var selectedPhoto: UIImage?
    var showErrorToast = false
    var showSuccessToast = false
}
