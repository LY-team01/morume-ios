//
//  MoruMeBackground.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/23.
//

import SwiftUI

struct MoruMeBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 217/255, green: 255/255, blue: 255/255),
                Color(red: 255/255, green: 226/255, blue: 235/255)
            ]),
            startPoint: .topLeading,
        endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    MoruMeBackground()
}
