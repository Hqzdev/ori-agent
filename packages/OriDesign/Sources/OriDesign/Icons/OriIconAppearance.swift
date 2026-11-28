#if os(iOS)
import UIKit

@MainActor
public enum OriIconAppearance {
    public static func configureNavigation() {
        let image = UIImage(named: OriGlyph.chevronLeft.assetName, in: .module, compatibleWith: nil)?
            .withRenderingMode(.alwaysTemplate)
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }
}
#endif
