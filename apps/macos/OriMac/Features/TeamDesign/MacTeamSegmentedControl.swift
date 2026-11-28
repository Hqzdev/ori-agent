import OriDesign
import SwiftUI

struct MacTeamSegmentedControl: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    @Namespace private var indicator
    private let inset: CGFloat = 3

    var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.self) { tab in
                let selected = selection == tab
                Button {
                    selection = tab
                } label: {
                    Text(tab)
                        .font(.system(size: 12, weight: selected ? .semibold : .medium))
                        .foregroundStyle(selected ? OriColor.onInverse : WorkspaceStyle.ink)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, minHeight: 30)
                        .background {
                            if selected {
                                RoundedRectangle(cornerRadius: OriRadius.control, style: .continuous)
                                    .fill(OriColor.inverse)
                                    .matchedGeometryEffect(id: "selection", in: indicator)
                            }
                        }
                        .contentShape(RoundedRectangle(cornerRadius: OriRadius.control, style: .continuous))
                }
                .buttonStyle(OriPlainButtonStyle(showsHover: !selected))
                .accessibilityAddTraits(selected ? [.isSelected] : [])
            }
        }
        .padding(inset)
        .background(WorkspaceStyle.surface, in: RoundedRectangle(cornerRadius: OriRadius.control + inset, style: .continuous))
        .kAnimation(KMotion.standard, value: selection)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(Text(LocalizedStringKey(title)))
    }
}
