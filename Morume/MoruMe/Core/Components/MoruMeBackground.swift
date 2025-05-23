//
//  MoruMeBackground.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/23.
//

import SwiftUI
import DynamicColor

struct MoruMeBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: 0xD9FFFF), // 左上の色 (整数値で指定)
                Color(hex: 0xFFE2EB)  // 右下の色 (整数値で指定)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    MoruMeBackground()
}
