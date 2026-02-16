import SwiftUI
import UIKit

enum AppFont {

    enum Family {
        static let iMedium = "Inter28pt-Medium"
        static let iRegular = "Inter28pt-Regular"
    }

    enum Weight {
        case regular
        case medium
    }

    static func inter(size: CGFloat, weight: Weight) -> Font {
        let name: String
        switch weight {
        case .regular: name = Family.iRegular
        case .medium:  name = Family.iMedium
        }

        return Font(uiFont: makeUIFont(name: name, size: size))
    }

    private static func makeUIFont(name: String, size: CGFloat) -> UIFont {
        if let custom = UIFont(name: name, size: size) {
            return custom
        }

        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
}

extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}
