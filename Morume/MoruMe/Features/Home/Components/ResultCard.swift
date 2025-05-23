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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ImageDisplayView(image: image, maxWidth: geometry.size.width * 0.9)
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
            .frame(width: geometry.size.width * 0.9)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.2), radius: 12, x: 0, y: 4)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}

struct ImageDisplayView: View {
    let image: UIImage
    let maxWidth: CGFloat
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: maxWidth - 24, height: (maxWidth - 24) * 0.7) // 横長の比率
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)
            .padding(.top, 16)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ResultCard(
        image: UIImage(systemName: "photo") ?? UIImage()
    ) {}
}
