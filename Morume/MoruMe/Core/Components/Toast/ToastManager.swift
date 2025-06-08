import Observation
import SwiftUI

@Observable
final class ToastManager {
    var toastState: ToastState?

    func show(icon: ImageResource, message: String, type: ToastType) {
        toastState = ToastState(icon: icon, message: message, type: type)
    }

    func dismiss() {
        toastState = nil
    }
}
