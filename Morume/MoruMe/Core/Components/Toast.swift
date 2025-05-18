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
    
    // 画面の幅に合わせてトーストの幅を調整
    @Environment(\.screenSize) private var screenSize
    
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

// 画面サイズを取得するための環境値
private struct ScreenSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = UIScreen.main.bounds.size
}

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}

// プレビュー用
struct Toast_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            Toast(iconName: "checkmark_circle_icon", message: "フィルターを作成しました")
                .padding(.top, 60) // 通知バーの下ぐらいの位置に
        }
        .previewDevice("iPhone 16 Pro")
    }
}