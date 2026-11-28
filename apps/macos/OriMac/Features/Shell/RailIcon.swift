import OriDesign
import SwiftUI

enum RailIcon {
    case home, symbol(String)

    @ViewBuilder func image(color: Color) -> some View {
        switch self {
        case .home:
            OriIcon(.home, size: 20).foregroundStyle(color)
        case .symbol(let name): KIcon(name, size: 20, color: color)
        }
    }
}
