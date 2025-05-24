//
//  ResultCard.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/23.
//

import SwiftUI

struct ResultCard: View {
    let image: UIImage
    let onSave: () -> Void
    var body: some View {
        VStack(spacing: 0) {
            ImageDisplayView(image: image)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 20)

            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    SaveButton(action: onSave)
                    ShareButton(image: image)
                }
                VStack(spacing: 0) {
                    Text("みんなそれぞれのフィルターで最高に可愛く！")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.morumePink)
                    HStack(spacing: 0) {
                        Text("morumeで思い出をもっと素敵に")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Color.morumePink)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .frame(width: UIScreen.main.bounds.width * 0.9)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
    }
}

struct ImageDisplayView: View {
    let image: UIImage
    var body: some View {
        let imageAreaWidth = UIScreen.main.bounds.width * 0.9 - 32
        let imageMaxHeight = imageAreaWidth * 0.75

        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .frame(maxHeight: imageMaxHeight)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ResultCard(
        image: UIImage(systemName: "photo") ?? UIImage()
    ) {}
    .border(.blue)
}
