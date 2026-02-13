import SwiftUI

import Foundation

enum OnboardingPage: Int, CaseIterable, Identifiable {
    case page1 = 0
    case page2 = 1
    case page3 = 2
    case page4 = 3
    case page5 = 4

    var id: Int { rawValue }
}



struct OnboardingPageView: View {

    let page: OnboardingPage

    var body: some View {
        Group {
            switch page {
            case .page1:
                OnboardingPage1View()
            case .page2:
                OnboardingPage2View()
            case .page3:
                OnboardingPage3View()
            case .page4:
                OnboardingPage4View()
            case .page5:
                OnboardingPage5View()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
