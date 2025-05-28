//
//  FilterSlider.swift
//  MoruMe
//
//  Created by Taisuke Numao on 2025/05/22.
//

import SwiftUI

struct FilterSlider: View {
    let label: String
    @Binding var value: Int

    init(label: String, value: Binding<Int>) {
        self.label = label
        self._value = value
        let thumbImage = ImageRenderer(content: SliderThumb())
        thumbImage.scale = UIScreen.main.scale
        UISlider.appearance().setThumbImage(thumbImage.uiImage!, for: .normal)
        UISlider.appearance().minimumTrackTintColor = UIColor(Color.morumePink)
        UISlider.appearance().maximumTrackTintColor = UIColor(Color.morumeBlue)
    }
    let sliderWidth = UIScreen.main.bounds.width * 0.75
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(label)
                    .foregroundColor(Color.morumePink)
                    .font(.system(size: 18))
                Spacer()
                Text("\(Int(value))")
                    .foregroundColor(Color.morumePink)
                    .font(.system(size: 18))
            }
            Slider(value: .convert($value), in: -100...100, step: 1)
                .sensoryFeedback(.selection, trigger: value)
        }
    }
}

struct SliderThumb: View {
    var body: some View {
        Circle()
            .fill(Color.white)
            .stroke(Color.morumePink, lineWidth: 2)
            .frame(width: 28, height: 28)
            .padding(1)
    }
}

extension Binding {
    public static func convert<TInt, TFloat>(_ intBinding: Binding<TInt>) -> Binding<TFloat>
    where
        TInt: BinaryInteger,
        TFloat: BinaryFloatingPoint
    {
        Binding<TFloat>(
            get: { TFloat(intBinding.wrappedValue) },
            set: { intBinding.wrappedValue = TInt($0) }
        )
    }
}

#Preview("FilterSlider") {
    @Previewable @State var mouth = 0
    @Previewable @State var eyes = 0
    @Previewable @State var nose = 0

    VStack(spacing: 16) {
        FilterSlider(label: "口", value: $mouth)
        FilterSlider(label: "目", value: $eyes)
        FilterSlider(label: "鼻", value: $nose)
    }
    .padding()
}

#Preview("SliderThumb") {
    SliderThumb()
}
