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
    let iconName: String
    let message: String
    let type: ToastType
    init(iconName: String, message: String, type: ToastType = .success) {
        self.iconName = iconName
        self.message = message
        self.type = type
    }
    var body: some View {
        HStack(spacing: 8) {
            Image(iconName)
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
// プレビュー用
#Preview {
    VStack(spacing: 20) {
        Toast(iconName: "checkmark_circle_icon", message: "フィルターを作成しました")
        Toast(iconName: "error_icon", message: "エラーが発生しました", type: .error)
    }
}
