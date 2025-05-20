//
//  ShareButton.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/20.
//

import SwiftUI
import UniformTypeIdentifiers

// UIImageをTransferableプロトコルに準拠させる拡張
extension UIImage: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .png) { image in
            image.pngData() ?? Data()
        } importing: { data in
            UIImage(data: data) ?? UIImage()
        }
    }
}

struct ShareButton: View {
    let image: UIImage
    var body: some View {
        ShareLink(item: image, preview: SharePreview("morumeの写真をシェア", image: Image(uiImage: image))) {
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
    ShareButton(image: UIImage(systemName: "photo") ?? UIImage())
}
