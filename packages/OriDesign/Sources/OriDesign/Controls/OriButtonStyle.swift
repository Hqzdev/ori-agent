//
//  OriButtonStyle.swift
//  OriDesign
//
//  Neutral controls. Every state is told apart by fill and outline, never by hue:
//  hover adds a 5 % veil, press a 10 % veil, focus a 2 pt ink ring, disabled greys the label
//  and drops the fill.
//

import SwiftUI

nonisolated public enum OriButtonKind: Sendable, Equatable {
    /// Panel fill with a hairline border — the default action.
    case secondary
    /// Ink fill with paper label — the one main action on a screen (send, sign in).
    case primary
    /// No fill until hovered — toolbars and inline actions.
    case ghost
    /// Bordered like `secondary`, semibold label; pair it with a trash or warning icon and a
    /// clear verb, because colour is not used.
    case destructive
    /// Bordered capsule — reserved for the sign-in entry.
    case pill
}

nonisolated public enum OriControlSize: Sendable, Equatable {
    case compact, regular, large

    public var height: CGFloat {
        switch self {
        case .compact: 28
        case .regular: OriLayout.controlHeight
        case .large: OriLayout.controlHeightLarge
        }
    }
}

public struct OriButtonStyle: ButtonStyle {
    public var kind: OriButtonKind
    public var size: OriControlSize
    public var fullWidth: Bool

    public init(_ kind: OriButtonKind = .secondary, size: OriControlSize = .regular, fullWidth: Bool = false) {
        self.kind = kind
        self.size = size
        self.fullWidth = fullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        OriButtonBody(label: configuration.label, pressed: configuration.isPressed,
                       kind: kind, size: size, fullWidth: fullWidth)
    }
}

private struct OriButtonBody<Label: View>: View {
    @Environment(\.isEnabled) private var enabled
    @State private var hovering = false
    @Environment(\.oriReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    let label: Label
    let pressed: Bool
    let kind: OriButtonKind
    let size: OriControlSize
    let fullWidth: Bool

    var body: some View {
        label
            .font(OriFont.role(.caption, weight: kind == .destructive ? .semibold : .medium))
            .lineLimit(1)
            .foregroundStyle(foreground)
            .padding(.horizontal, size == .compact ? OriSpace.s8 : OriSpace.s12)
            .frame(minHeight: size.height)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background { shape.fill(fill) }
            .overlay { shape.fill(veil) }
            .overlay { shape.strokeBorder(border, lineWidth: OriLayout.hairlineWidth) }
            .contentShape(shape)
            .oriFocusRing(radius: 16)
            .modifier(OriPressFeedback(pressed: enabled && pressed, scale: 0.98))
            .onHover { hovering = $0 }
            .animation(reduceMotion || systemReduceMotion ? nil : OriInterfaceMotion.quick, value: hovering)
            .animation(reduceMotion || systemReduceMotion ? nil : OriInterfaceMotion.press, value: pressed)
    }

    /// The pill uses an oversized radius, which SwiftUI clamps to a capsule.
    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: kind == .pill ? 999 : 16, style: .continuous)
    }

    private var foreground: Color {
        guard enabled else { return OriColor.textTertiary }
        return kind == .primary ? OriColor.onInverse : kind == .destructive ? .red : OriColor.text
    }

    private var fill: Color {
        switch kind {
        case .primary: enabled ? OriColor.inverse : OriColor.fill
        case .ghost: .clear
        case .secondary, .destructive, .pill: OriColor.panel
        }
    }

    /// Hover and press veils sit on top of the fill so they also work on the ink button.
    private var veil: Color {
        guard enabled else { return .clear }
        if kind == .primary {
            return pressed ? OriColor.canvas.opacity(0.24) : hovering ? OriColor.canvas.opacity(0.12) : .clear
        }
        return pressed ? OriColor.pressed : hovering ? OriColor.hover : .clear
    }

    private var border: Color {
        switch kind {
        case .primary, .ghost: .clear
        case .secondary, .destructive, .pill:
            enabled && (hovering || pressed) ? OriColor.hairlineStrong : OriColor.hairline
        }
    }
}

/// Square icon button: transparent until hovered, grey fill when selected.
public struct OriIconButtonStyle: ButtonStyle {
    public var size: CGFloat
    public var selected: Bool

    public init(size: CGFloat = OriLayout.iconButton, selected: Bool = false) {
        self.size = size
        self.selected = selected
    }

    public func makeBody(configuration: Configuration) -> some View {
        OriIconButtonBody(label: configuration.label, pressed: configuration.isPressed,
                           size: size, selected: selected)
    }
}

private struct OriIconButtonBody<Label: View>: View {
    @Environment(\.isEnabled) private var enabled
    @State private var hovering = false
    let label: Label
    let pressed: Bool
    let size: CGFloat
    let selected: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: OriRadius.control, style: .continuous)
        label
            .foregroundStyle(enabled ? OriColor.text : OriColor.textTertiary)
            .frame(width: size, height: size)
            .background(shape.fill(fill))
            .contentShape(shape)
            .oriFocusRing()
            .modifier(OriPressFeedback(pressed: enabled && pressed, scale: 0.96))
            .onHover { hovering = $0 }
    }

    private var fill: Color {
        guard enabled else { return .clear }
        if pressed { return OriColor.pressed }
        if selected { return OriColor.selected }
        return hovering ? OriColor.hover : .clear
    }
}

/// Ink send button with an arrow. Shows a spinner while sending and a retry arrow after a failure.
public struct OriSendButton: View {
    nonisolated public enum Phase: Sendable, Equatable { case ready, sending, retry }

    private let phase: Phase
    private let size: CGFloat
    private let action: () -> Void

    public init(phase: Phase = .ready, size: CGFloat = OriLayout.iconButton, action: @escaping () -> Void) {
        self.phase = phase
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Group {
                switch phase {
                case .sending: ProgressView().controlSize(.small).tint(OriColor.onInverse)
                case .retry: OriIcon(symbol: "arrow.clockwise", size: size * 0.46).font(.system(size: size * 0.46, weight: .semibold))
                case .ready: OriIcon(symbol: "arrow.up", size: size * 0.5).font(.system(size: size * 0.5, weight: .semibold))
                }
            }
            .frame(width: size, height: size)
        }
        .buttonStyle(OriSendButtonStyle())
        .disabled(phase == .sending)
        .accessibilityLabel(phase == .sending ? "Sending" : phase == .retry ? "Retry sending" : "Send message")
    }
}

private struct OriSendButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        OriSendButtonBody(label: configuration.label, pressed: configuration.isPressed)
    }
}

private struct OriSendButtonBody<Label: View>: View {
    @Environment(\.isEnabled) private var enabled
    let label: Label
    let pressed: Bool

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: OriRadius.control, style: .continuous)
        label
            .foregroundStyle(enabled ? OriColor.onInverse : OriColor.textTertiary)
            .background(shape.fill(enabled ? OriColor.inverse : OriColor.fill))
            .overlay(shape.fill(pressed && enabled ? OriColor.canvas.opacity(0.24) : .clear))
            .contentShape(shape)
    }
}
