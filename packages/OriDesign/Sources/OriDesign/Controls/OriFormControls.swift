import SwiftUI

public extension EnvironmentValues {
    /// Only persistent chat navigation and composer controls opt into glass.
    @Entry var oriChatChrome = false
}

public struct OriTextFieldStyle: TextFieldStyle {
    @FocusState private var focused: Bool
    @Environment(\.isEnabled) private var enabled
    @Environment(\.oriReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    public init() {}
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration.textFieldStyle(.plain)
            .padding(.horizontal, 14).padding(.vertical, 12)
            .background(OriColor.fill, in: RoundedRectangle(cornerRadius: 16))
            .focused($focused).focusEffectDisabled()
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(focused ? OriColor.focusRing : OriColor.hairline, lineWidth: focused ? 1.5 : 1)
                    .allowsHitTesting(false)
            }
            .opacity(enabled ? 1 : 0.45)
            .animation(reduceMotion || systemReduceMotion ? nil : OriInterfaceMotion.quick, value: focused)
    }
}

public struct OriToggleStyle: ToggleStyle {
    private let showsLabel: Bool
    @Environment(\.oriReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    public init(showsLabel: Bool = true) { self.showsLabel = showsLabel }
    public func makeBody(configuration: Configuration) -> some View {
        Button { configuration.isOn.toggle() } label: {
            HStack(spacing: 16) {
                if showsLabel { configuration.label; Spacer(minLength: 8) }
                Capsule().fill(configuration.isOn ? OriColor.inverse : OriColor.text.opacity(0.16))
                    .frame(width: 40, height: 24)
                    .overlay(alignment: .leading) {
                        Circle().fill(configuration.isOn ? OriColor.onInverse : Color.white)
                            .frame(width: 18, height: 18).padding(3).offset(x: configuration.isOn ? 16 : 0)
                    }
            }.frame(minHeight: 44).contentShape(RoundedRectangle(cornerRadius: 14))
        }.buttonStyle(OriPlainButtonStyle()).oriFocusRing()
            .animation(reduceMotion || systemReduceMotion ? nil : OriInterfaceMotion.standard, value: configuration.isOn)
            .accessibilityRepresentation {
                Toggle(isOn: configuration.$isOn) { configuration.label }.toggleStyle(.switch)
            }
    }
}

public extension View {
    func oriChromeSurface(cornerRadius: CGFloat = 22) -> some View {
        modifier(OriChromeSurface(radius: cornerRadius))
    }
}

private struct OriChromeSurface: ViewModifier {
    let radius: CGFloat
    @Environment(\.oriChatChrome) private var chat
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    func body(content: Content) -> some View {
        if chat && !reduceTransparency {
            content.glassEffect(.regular.interactive(), in: .rect(cornerRadius: radius))
        } else {
            content.oriPanel(fill: OriColor.panel, radius: radius)
        }
    }
}

public struct OriDisclosureStyle: DisclosureGroupStyle {
    @Environment(\.oriReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Button { configuration.isExpanded.toggle() } label: {
                HStack(spacing: 12) {
                    configuration.label
                    Spacer(minLength: 8)
                    OriIcon(.chevronDown, size: 16).rotationEffect(.degrees(configuration.isExpanded ? 180 : 0))
                }.frame(minHeight: 44).contentShape(RoundedRectangle(cornerRadius: 14))
            }.buttonStyle(OriPlainButtonStyle()).oriFocusRing()
                .accessibilityValue(configuration.isExpanded ? Text("Expanded") : Text("Collapsed"))
            if configuration.isExpanded { configuration.content.transition(.opacity) }
        }.animation(reduceMotion || systemReduceMotion ? nil : OriInterfaceMotion.standard, value: configuration.isExpanded)
    }
}

public struct OriProgressStyle: ProgressViewStyle {
    @Environment(\.controlSize) private var controlSize
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.oriReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    public init() {}
    private var size: CGFloat { controlSize == .mini ? 12 : controlSize == .small ? 16 : 22 }
    public func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if let fraction = configuration.fractionCompleted {
                GeometryReader { geometry in
                    Capsule().fill(OriColor.selected)
                        .overlay(alignment: .leading) {
                            Capsule().fill(.foreground).frame(width: geometry.size.width * min(1, max(0, fraction)))
                        }
                }.frame(height: 5)
            } else {
                TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion || systemReduceMotion || scenePhase != .active)) { context in
                    Circle().trim(from: 0.1, to: 0.8).stroke(style: StrokeStyle(lineWidth: 1.7, lineCap: .round))
                        .rotationEffect(.degrees(reduceMotion || systemReduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 1) * 360))
                        .frame(width: size, height: size)
                }
            }
            configuration.label
            configuration.currentValueLabel
        }
    }
}
