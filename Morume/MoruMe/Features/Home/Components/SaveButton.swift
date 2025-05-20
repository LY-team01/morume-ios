//
//  SaveButton.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/20.
//

import SwiftUI

struct SaveButton: View {
    let action: () -> Void
    init(action: @escaping () -> Void) {
        self.action = action
    }
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image("photo_saved_icon")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                Text("保存する")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
            }
            .frame(width: UIScreen.main.bounds.width * 0.38, height: 50)
            .background(Color.morumePink)
            .cornerRadius(30)
        }
    }
}

#Preview {
    SaveButton(action: {})
}
