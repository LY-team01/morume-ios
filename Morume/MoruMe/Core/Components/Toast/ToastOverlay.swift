//
//  ToastOverlay.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/28.
//

import SwiftUI

struct ToastOverlay: ViewModifier {
    @Environment(ToastManager.self) private var toastManager

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if let toastState = toastManager.toastState {
                    Toast(icon: toastState.icon, message: toastState.message, type: toastState.type)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .task(id: toastState.id) {
                            try? await Task.sleep(for: .seconds(3))
                            await MainActor.run {
                                withAnimation {
                                    toastManager.dismiss()
                                }
                            }
                        }
                }
                Spacer()
            }
        }
    }
}
