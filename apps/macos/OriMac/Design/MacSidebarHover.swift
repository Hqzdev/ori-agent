import OriDesign
import SwiftUI

extension EnvironmentValues {
    @Entry var macSidebarTracksHover = false
}

extension View {
    func macSidebarHoverTarget(radius: CGFloat? = nil) -> some View {
        anchorPreference(key: SidebarHoverBounds.self, value: .bounds) { [.init(bounds: $0, radius: radius)] }
    }

    func macSidebarHoverSection(radius: CGFloat) -> some View {
        modifier(SidebarHoverSection(radius: radius))
    }
}

private struct SidebarHoverBounds: PreferenceKey {
    struct Target {
        let bounds: Anchor<CGRect>
        let radius: CGFloat?
    }
    static var defaultValue: [Target] { [] }
    static func reduce(value: inout [Target], nextValue: () -> [Target]) {
        value.append(contentsOf: nextValue())
    }
}

private struct SidebarHoverSection: ViewModifier {
    let radius: CGFloat
    @State private var pointer: CGPoint?
    @Environment(\.controlActiveState) private var windowState

    func body(content: Content) -> some View {
        content
            .environment(\.macSidebarTracksHover, true)
            .overlayPreferenceValue(SidebarHoverBounds.self) { anchors in
                GeometryReader { geometry in
                    if windowState != .inactive, let pointer,
                       let target = anchors.first(where: { geometry[$0.bounds].contains(pointer) }) {
                        let frame = geometry[target.bounds]
                        RoundedRectangle(cornerRadius: target.radius ?? radius, style: .continuous)
                            .fill(OriColor.hover)
                            .frame(width: frame.width, height: frame.height)
                            .position(x: frame.midX, y: frame.midY)
                    }
                }.clipped().allowsHitTesting(false).accessibilityHidden(true)
            }
            .onContinuousHover { phase in
                switch phase {
                case .active(let location): pointer = location
                case .ended: pointer = nil
                }
            }
            .onChange(of: windowState) { _, state in
                if state == .inactive { pointer = nil }
            }
            .transformPreference(SidebarHoverBounds.self) { $0.removeAll() }
    }
}
