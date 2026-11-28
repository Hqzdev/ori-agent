import SwiftUI

struct OriPressFeedback: ViewModifier {
    let pressed: Bool
    var scale: CGFloat = 0.98
    @Environment(\.oriReduceMotion) private var preference
    @Environment(\.accessibilityReduceMotion) private var system

    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed && !(preference || system) ? scale : 1)
            .animation(preference || system ? nil : OriInterfaceMotion.press, value: pressed)
    }
}

public struct OriPlainButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var enabled
    private let disabledOpacity: Double
    public init(disabledOpacity: Double = 0.4) { self.disabledOpacity = disabledOpacity }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(enabled ? (configuration.isPressed ? 0.78 : 1) : disabledOpacity)
            .modifier(OriPressFeedback(pressed: enabled && configuration.isPressed, scale: 0.99))
    }
}
