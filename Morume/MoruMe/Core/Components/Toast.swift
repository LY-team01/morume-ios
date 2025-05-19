//
//  Toast.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/18.
//

import SwiftUI

struct Toast: View {
    let iconName: String
    let message: String
    var body: some View {
        HStack(spacing: 8) {
            Image(iconName)
                .renderingMode(.template)
                .foregroundColor(Color(UIColor.white))
                .frame(width: 20, height: 20)
            Text(message)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(Color(UIColor.white))
            Spacer()
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width * 0.85)
        .background(Color.morumeGreen)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 4)
    }
}
// プレビュー用
#Preview {
    Toast(iconName: "checkmark_circle_icon", message: "フィルターを作成しました")
}
