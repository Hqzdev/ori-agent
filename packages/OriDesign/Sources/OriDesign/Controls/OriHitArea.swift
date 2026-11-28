import SwiftUI

public extension View {
    /// Makes empty space inside a control's existing bounds participate in interaction.
    func oriHitArea() -> some View {
        contentShape(.interaction, Rectangle())
    }
}

/// Enlarges a custom control's real button bounds, then restores its original layout footprint.
public struct OriHitTargetButtonStyle: PrimitiveButtonStyle {
    private let expansion: CGFloat
    private let hoverShape: AnyShape
    private let hoverColor: Color

    public init(expansion: CGFloat = 4, hoverIn shape: some Shape = RoundedRectangle(cornerRadius: 10), hoverColor: Color = OriColor.hover) {
        self.expansion = max(0, expansion)
        hoverShape = AnyShape(shape)
        self.hoverColor = hoverColor
    }

    public func makeBody(configuration: Configuration) -> some View {
        Button(role: configuration.role, action: configuration.trigger) {
            configuration.label.oriHover(in: hoverShape, color: hoverColor).padding(expansion).oriHitArea()
        }.buttonStyle(OriPlainButtonStyle(showsHover: false)).padding(-expansion)
    }
}

/// A transparent halo leaves a native glass button's artwork, keyboard handling and focus intact.
struct OriButtonHitHalo: ViewModifier {
    let expansion: CGFloat
    let action: () -> Void
    @Environment(\.isEnabled) private var enabled

    func body(content: Content) -> some View {
        content.overlay {
            Color.clear
                .contentShape(.interaction, Halo(inset: expansion), eoFill: true)
                .onTapGesture(perform: action)
                .allowsHitTesting(enabled)
                .accessibilityHidden(true)
                .padding(-expansion)
        }
    }

    nonisolated private struct Halo: Shape {
        let inset: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path(rect)
            path.addPath(Capsule().path(in: rect.insetBy(dx: inset, dy: inset)))
            return path
        }
    }
}
