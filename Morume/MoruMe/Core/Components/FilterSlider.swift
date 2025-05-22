//
//  FilterSlider.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/22.
//

import SwiftUI

struct FilterSlider: View {
    let label: String
    @Binding var value: Double
    // デフォルト値
    init(label: String) {
        self.label = label
        self._value = .constant(50)
    }
    // 値を注入
    init(label: String, value: Binding<Double>) {
        self.label = label
        self._value = value
    }
    let sliderWidth = UIScreen.main.bounds.width * 0.75
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(label)
                    .foregroundColor(Color.morumePink)
                    .font(.system(size: 18))
                Spacer()
                Text("\(Int(value))%")
                    .foregroundColor(Color.morumePink)
                    .font(.system(size: 18))
            }
            ZStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.morumePink)
                        .frame(width: (sliderWidth - 28) * value / 100 + 14, height: 4)
                    Rectangle()
                        .fill(Color.morumeBlue)
                        .frame(width: sliderWidth - ((sliderWidth - 28) * value / 100 + 14), height: 4)
                }
                .cornerRadius(5)
                Circle()
                    .fill(Color.white)
                    .frame(width: 28, height: 28)
                    .overlay(
                        Circle()
                            .stroke(Color.morumePink, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .offset(x: (sliderWidth - 28) * value / 100)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                updateValue(with: gesture)
                            }
                    )
            }
        }
        .frame(width: sliderWidth)
        .padding(.vertical, 8)
    }
    private func updateValue(with gesture: DragGesture.Value) {
        let dragLocation = gesture.location.x
        let cappedValue = min(max(dragLocation, 0), sliderWidth - 28)
        value = Double((cappedValue / (sliderWidth - 28)) * 100)
        value = Double(Int(value))
    }
}

#Preview {
    VStack {
        FilterSlider(label: "口")
        FilterSlider(label: "目", value: .constant(70))
        FilterSlider(label: "鼻", value: .constant(30))
    }
}
