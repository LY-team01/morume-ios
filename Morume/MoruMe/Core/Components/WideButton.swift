import SwiftUI

struct WideButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.isEnabled) private var isEnabled
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(isEnabled ? .white : Color(.systemGray3))
                .frame(minHeight: 50)
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .background(isEnabled ? Color.morumeGreen : Color(.systemGray5))
        .cornerRadius(30)
    }
}

#Preview {
    VStack(spacing: 50) {
        WideButton(title: "フィルターを作成") {}
        WideButton(title: "フィルターを作成") {}
            .disabled(true)
    }
}
