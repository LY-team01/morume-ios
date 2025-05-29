//
//  ToastOverlay.swift
//  MoruMe
//
//  Created by 青原光 on 2025/05/28.
//

import SwiftUI

struct ToastOverlay: ViewModifier {
    @Binding var showToast: Bool
    let icon: ImageResource
    let message: String
    let type: ToastType

    func body(content: Content) -> some View {
        ZStack {
            content
            VStack {
                if showToast {
                    Toast(icon: icon, message: message, type: type)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .task(id: showToast) {
                            try? await Task.sleep(for: .seconds(3))
                            await MainActor.run {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                }
                Spacer()
            }
        }
    }
}
