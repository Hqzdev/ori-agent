import OriDesign
import SwiftUI

struct MacTeamFileIcon: View {
    let filename: String
    var size: CGFloat = 28

    var body: some View {
        OriIcon(MacTeamFileKind(filename: filename).glyph, size: size)
    }
}
