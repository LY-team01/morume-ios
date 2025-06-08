//
//  Toast.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/18.
//  Modified by Taisuke Numao on 2025/05/21.
//

import SwiftUI

enum ToastType {
    case success
    case error

    var backgroundColor: Color {
        switch self {
        case .success:
            return Color.morumeGreen
        case .error:
            return Color.morumePink
        }
    }
}

struct Toast: View {
    let icon: ImageResource
    let message: String
    let type: ToastType

    init(icon: ImageResource, message: String, type: ToastType) {
        self.icon = icon
        self.message = message
        self.type = type
    }

    var body: some View {
        HStack(spacing: 8) {
            Image(icon)
                .renderingMode(.template)
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
            Text(message)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .background(type.backgroundColor)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    VStack(spacing: 20) {
        Toast(icon: .checkmarkCircleIcon, message: "フィルターを作成しました", type: .success)
        Toast(icon: .errorIcon, message: "エラーが発生しました", type: .error)
    }
}
