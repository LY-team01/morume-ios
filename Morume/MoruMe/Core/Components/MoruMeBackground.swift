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
                Color("GradientStartColor"),
                Color("GradientEndColor")
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
