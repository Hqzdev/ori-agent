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
    private let hoverShape: AnyShape?

    public init(disabledOpacity: Double = 0.4, showsHover: Bool = true) {
        self.disabledOpacity = disabledOpacity
        hoverShape = showsHover ? AnyShape(RoundedRectangle(cornerRadius: 10)) : nil
    }

    public init(disabledOpacity: Double = 0.4, hoverIn shape: some Shape) {
        self.disabledOpacity = disabledOpacity
        hoverShape = AnyShape(shape)
    }

    @ViewBuilder public func makeBody(configuration: Configuration) -> some View {
        let label = configuration.label
            .oriHitArea()
            .opacity(enabled ? (configuration.isPressed ? 0.78 : 1) : disabledOpacity)
            .modifier(OriPressFeedback(pressed: enabled && configuration.isPressed, scale: 0.99))
        #if os(macOS)
        if let hoverShape { label.oriHover(in: hoverShape) }
        else { label }
        #else
        label
        #endif
    }
}

public struct OriSecondaryTextButtonStyle: PrimitiveButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        #if os(macOS)
        Button(configuration)
            .buttonStyle(OriPlainButtonStyle(showsHover: false))
            .modifier(OriSecondaryTextHover())
        #else
        Button(configuration)
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
        #endif
    }
}

public extension View {
    /// Tints an action within its existing outline without changing its layout or hit target.
    @ViewBuilder func oriHover(in shape: some Shape, color: Color = OriColor.hover) -> some View {
        #if os(macOS)
        modifier(OriHoverFeedback(shape: shape, color: color))
        #else
        self
        #endif
    }
}

#if os(macOS)
private struct OriSecondaryTextHover: ViewModifier {
    @Environment(\.isEnabled) private var enabled
    @Environment(\.oriReduceMotion) private var preference
    @Environment(\.accessibilityReduceMotion) private var system
    @State private var hovering = false

    func body(content: Content) -> some View {
        let highlighted = enabled && hovering
        content
            .foregroundStyle(highlighted ? OriColor.text : OriColor.textSecondary)
            .animation(preference || system ? nil : OriInterfaceMotion.quick, value: highlighted)
            .onHover { hovering = $0 }
    }
}

private struct OriHoverFeedback<Outline: Shape>: ViewModifier {
    let shape: Outline
    let color: Color
    @Environment(\.isEnabled) private var enabled
    @Environment(\.oriReduceMotion) private var preference
    @Environment(\.accessibilityReduceMotion) private var system
    @State private var hovering = false

    func body(content: Content) -> some View {
        content
            .overlay {
                shape.fill(color)
                    .opacity(enabled && hovering ? 1 : 0)
                    .animation(preference || system ? nil : OriInterfaceMotion.quick, value: enabled && hovering)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
            .onHover { hovering = $0 }
    }
}
#endif
