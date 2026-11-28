//
//  OriColor.swift
//  OriDesign
//
//  Monochrome palette: graphite ink on paper in the light theme, the same roles on charcoal in
//  the dark theme. Colour never carries meaning on its own — state is shown with text, icons,
//  weight, fills and outlines.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

/// A colour for each appearance, written as 0xRRGGBBAA.
nonisolated public struct OriColorPair: Sendable, Equatable {
    public let light: UInt32
    public let dark: UInt32

    public init(light: UInt32, dark: UInt32) {
        self.light = light
        self.dark = dark
    }

    public init(_ both: UInt32) {
        self.init(light: both, dark: both)
    }
}

/// Raw values of every role. Kept separate from `Color` so tests can check contrast.
nonisolated public enum OriPalette {
    /// Main reading surface: conversation, pages.
    public static let canvas = OriColorPair(light: 0xFFFFFFFF, dark: 0x212121FF)
    /// Sidebar and secondary chrome.
    public static let sidebar = OriColorPair(light: 0xF9F9F9FF, dark: 0x171717FF)
    /// Panels, menus, popovers, sheets and the composer.
    public static let panel = OriColorPair(light: 0xFFFFFFFF, dark: 0x262626FF)
    /// Quiet filled surface: user messages, icon tiles, code and search fields.
    public static let fill = OriColorPair(light: 0xF4F4F4FF, dark: 0x303030FF)
    /// Tags and badges (square corners).
    public static let tag = OriColorPair(light: 0xF9F9F9FF, dark: 0x2A2A2AFF)
    public static let text = OriColorPair(light: 0x0D0D0DFF, dark: 0xECECECFF)
    public static let textSecondary = OriColorPair(light: 0x5D5D5DFF, dark: 0xB4B4B4FF)
    /// Disabled controls and placeholders only — not for text people need to read.
    public static let textTertiary = OriColorPair(0x8F8F8FFF)
    public static let hairline = OriColorPair(light: 0x0000001A, dark: 0xFFFFFF1A)
    public static let hairlineStrong = OriColorPair(light: 0x00000026, dark: 0xFFFFFF26)
    public static let edge = OriColorPair(light: 0xE6E6E6FF, dark: 0x3A3A3AFF)
    public static let hover = OriColorPair(light: 0x0000000D, dark: 0xFFFFFF0D)
    public static let selected = OriColorPair(light: 0x00000012, dark: 0xFFFFFF14)
    public static let pressed = OriColorPair(light: 0x0000001A, dark: 0xFFFFFF1F)
    public static let focusRing = OriColorPair(light: 0x0D0D0DFF, dark: 0xECECECFF)
    public static let inverse = OriColorPair(light: 0x0D0D0DFF, dark: 0xECECECFF)
    public static let onInverse = OriColorPair(light: 0xFFFFFFFF, dark: 0x0D0D0DFF)
    public static let tooltip = OriColorPair(0x000000FF)
    public static let onTooltip = OriColorPair(0xFFFFFFFF)
    public static let scrim = OriColorPair(0x00000080)
    /// Diff backgrounds: additions lighter, removals darker; the +/− sign and labels carry meaning.
    public static let diffAdded = OriColorPair(light: 0x0000000A, dark: 0xFFFFFF0A)
    public static let diffRemoved = OriColorPair(light: 0x0000001A, dark: 0xFFFFFF1C)
    /// Character accessories and effects: mid grey that reads on both ink and paper.
    public static let accent = OriColorPair(0x8F8F8FFF)
}

/// Appearance-aware colours for SwiftUI.
nonisolated public enum OriColor {
    public static let canvas = dynamic(OriPalette.canvas)
    public static let sidebar = dynamic(OriPalette.sidebar)
    public static let panel = dynamic(OriPalette.panel)
    public static let fill = dynamic(OriPalette.fill)
    public static let tag = dynamic(OriPalette.tag)
    public static let text = dynamic(OriPalette.text)
    public static let textSecondary = dynamic(OriPalette.textSecondary)
    public static let textTertiary = dynamic(OriPalette.textTertiary)
    public static let hairline = dynamic(OriPalette.hairline)
    public static let hairlineStrong = dynamic(OriPalette.hairlineStrong)
    public static let edge = dynamic(OriPalette.edge)
    public static let hover = dynamic(OriPalette.hover)
    public static let selected = dynamic(OriPalette.selected)
    public static let pressed = dynamic(OriPalette.pressed)
    public static let focusRing = dynamic(OriPalette.focusRing)
    public static let inverse = dynamic(OriPalette.inverse)
    public static let onInverse = dynamic(OriPalette.onInverse)
    public static let tooltip = dynamic(OriPalette.tooltip)
    public static let onTooltip = dynamic(OriPalette.onTooltip)
    public static let scrim = dynamic(OriPalette.scrim)
    public static let diffAdded = dynamic(OriPalette.diffAdded)
    public static let diffRemoved = dynamic(OriPalette.diffRemoved)
    public static let accent = dynamic(OriPalette.accent)

    /// Builds a colour that follows the effective appearance of the view, window or screen.
    /// The provider runs on whatever thread AppKit or UIKit resolves colours on, so it only
    /// captures plain values.
    public static func dynamic(_ pair: OriColorPair) -> Color {
        let light = pair.light
        let dark = pair.dark
        #if os(macOS)
        return Color(nsColor: NSColor(name: nil) { appearance in
            let isDark = appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
            return platformColor(isDark ? dark : light)
        })
        #else
        return Color(uiColor: UIColor { traits in
            platformColor(traits.userInterfaceStyle == .dark ? dark : light)
        })
        #endif
    }

    /// Opaque or translucent colour that is the same in both appearances.
    public static func constant(_ rgba: UInt32) -> Color {
        let c = OriRGBA(rgba)
        return Color(.sRGB, red: c.red, green: c.green, blue: c.blue, opacity: c.alpha)
    }

    #if os(macOS)
    private static func platformColor(_ rgba: UInt32) -> NSColor {
        let c = OriRGBA(rgba)
        return NSColor(srgbRed: c.red, green: c.green, blue: c.blue, alpha: c.alpha)
    }
    #else
    private static func platformColor(_ rgba: UInt32) -> UIColor {
        let c = OriRGBA(rgba)
        return UIColor(red: c.red, green: c.green, blue: c.blue, alpha: c.alpha)
    }
    #endif
}

/// Components of a 0xRRGGBBAA value in 0…1.
nonisolated public struct OriRGBA: Sendable, Equatable {
    public let red: Double
    public let green: Double
    public let blue: Double
    public let alpha: Double

    public init(_ rgba: UInt32) {
        red = Double((rgba >> 24) & 0xFF) / 255
        green = Double((rgba >> 16) & 0xFF) / 255
        blue = Double((rgba >> 8) & 0xFF) / 255
        alpha = Double(rgba & 0xFF) / 255
    }

    /// Colour composited over an opaque background.
    public func over(_ background: OriRGBA) -> OriRGBA {
        OriRGBA(red: red * alpha + background.red * (1 - alpha),
                 green: green * alpha + background.green * (1 - alpha),
                 blue: blue * alpha + background.blue * (1 - alpha),
                 alpha: 1)
    }

    /// WCAG relative luminance.
    public var luminance: Double {
        func linear(_ value: Double) -> Double {
            value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
    }

    /// WCAG contrast ratio between two opaque colours.
    public static func contrast(_ a: OriRGBA, _ b: OriRGBA) -> Double {
        let high = max(a.luminance, b.luminance), low = min(a.luminance, b.luminance)
        return (high + 0.05) / (low + 0.05)
    }

    private init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
}
