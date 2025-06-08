//
//  InitialViewModel.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/28.
//

import Observation
import UIKit

@Observable
final class InitialViewModel {
    var selectedPhoto: UIImage?
    var toastEvent: ToastState?
}
