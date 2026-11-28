//
//  OriSurfaces.swift
//  OriDesign
//
//  Flat surfaces. Elevation is a 1 pt hairline, never a shadow, blur or glass.
//

import SwiftUI

public extension View {
    /// Panel, card, menu or popover: filled shape with a hairline border and 10 pt corners.
    func oriPanel(fill: Color = OriColor.panel, radius: CGFloat = OriRadius.panel,
                   border: Color = OriColor.hairline) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        return background(shape.fill(fill))
            .overlay(shape.strokeBorder(border, lineWidth: OriLayout.hairlineWidth))
            .clipShape(shape)
    }

    /// Navigation or list row: clear by default, veil on hover, grey when selected.
    func oriRow(selected: Bool = false, radius: CGFloat = OriRadius.control) -> some View {
        modifier(OriRowBackground(selected: selected, radius: radius))
    }

    /// 2 pt ink ring while the view has keyboard focus.
    func oriFocusRing(radius: CGFloat = OriRadius.control) -> some View {
        modifier(OriFocusRing(radius: radius))
    }

    /// 1 pt separator along one edge.
    func oriHairline(_ edge: Edge, color: Color = OriColor.hairline) -> some View {
        overlay(alignment: edge.oriAlignment) {
            Rectangle()
                .fill(color)
                .frame(width: edge == .leading || edge == .trailing ? OriLayout.hairlineWidth : nil,
                       height: edge == .top || edge == .bottom ? OriLayout.hairlineWidth : nil)
                .allowsHitTesting(false)
        }
    }
}

private extension Edge {
    var oriAlignment: Alignment {
        switch self {
        case .top: .top
        case .bottom: .bottom
        case .leading: .leading
        case .trailing: .trailing
        }
    }
}

private struct OriRowBackground: ViewModifier {
    @Environment(\.isEnabled) private var enabled
    @State private var hovering = false
    let selected: Bool
    let radius: CGFloat

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        content
            .background(shape.fill(selected ? OriColor.selected : hovering && enabled ? OriColor.hover : .clear))
            .contentShape(shape)
            .onHover { hovering = $0 }
    }
}

private struct OriFocusRing: ViewModifier {
    @FocusState private var focused: Bool
    let radius: CGFloat

    func body(content: Content) -> some View {
        content
            .focused($focused)
            .overlay {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .strokeBorder(focused ? OriColor.focusRing : .clear, lineWidth: OriLayout.focusRingWidth)
                    .allowsHitTesting(false)
            }
    }
}

/// Full-width 1 pt divider.
public struct OriDivider: View {
    private let vertical: Bool

    public init(vertical: Bool = false) { self.vertical = vertical }

    public var body: some View {
        Rectangle()
            .fill(OriColor.hairline)
            .frame(width: vertical ? OriLayout.hairlineWidth : nil, height: vertical ? nil : OriLayout.hairlineWidth)
            .accessibilityHidden(true)
    }
}

/// Low-prominence label with square corners.
public struct OriTag: View {
    private let text: String
    private let mono: Bool

    public init(_ text: String, mono: Bool = false) {
        self.text = text
        self.mono = mono
    }

    public var body: some View {
        Text(text)
            .font(mono ? OriFont.mono(12, weight: .medium) : OriFont.role(.meta, weight: .medium))
            .foregroundStyle(OriColor.text)
            .lineLimit(1)
            .padding(.horizontal, OriSpace.element)
            .padding(.vertical, 2)
            .background(Rectangle().fill(OriColor.tag))
            .fixedSize()
    }
}

/// Modal backdrop: 50 % black, no blur.
public struct OriScrim: View {
    public init() {}
    public var body: some View {
        OriColor.scrim.ignoresSafeArea().accessibilityHidden(true)
    }
}
