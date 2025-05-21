//
//  ShareButton.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/21.
//

import SwiftUI

struct ShareButton: View {
    let image: UIImage
    var body: some View {
        ShareLink(item: Image(uiImage: image), preview: SharePreview("morumeの写真をシェア", image: Image(uiImage: image))) {
            HStack(spacing: 8) {
                Image("share_icon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
                    .foregroundStyle(Color.morumePink)
                Text("シェアする")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.morumePink)
            }
            .frame(width: UIScreen.main.bounds.width * 0.38, height: 50)
            .background(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.morumePink, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ShareButton(image: UIImage(systemName: "photo")!)
}
