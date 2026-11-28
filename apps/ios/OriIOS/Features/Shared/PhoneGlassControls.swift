import OriDesign
import SwiftUI

struct PhoneGlassCircleButton: View {
    let symbol: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            OriIcon(symbol: symbol, size: 22).font(.system(size: 21, weight: .regular))
                .frame(width: 44, height: 44)
                .oriChromeSurface(cornerRadius: 24)
                .oriHitArea()
        }.buttonStyle(OriHitTargetButtonStyle()).accessibilityLabel(title)
    }
}

struct PhoneGlassCapsule<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content.padding(.horizontal, 12).frame(minHeight: 44)
            .oriChromeSurface(cornerRadius: 24).oriHitArea()
    }
}

enum PhoneReferenceStyle {
    static var authentication: Color { OriColor.dynamic(.init(light: 0xF7F7F5FF, dark: 0x191919FF)) }
    static var field: Color { OriColor.dynamic(.init(light: 0xF1F1EFFF, dark: 0x242424FF)) }
    static var provider: Color { OriColor.dynamic(.init(light: 0xEAE8E6FF, dark: 0x303030FF)) }
}
