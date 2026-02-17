
import SwiftUI

struct OnboardingPage5View: View {
    var body: some View {
        ZStack {
            Color(hex: "1A0F0A")
                .ignoresSafeArea()

            VStack {
                Image(.onb5)
                Text("Your Journey Begins")
                    .font(AppFont.inter(size: 36, weight: .medium))
                    .foregroundStyle(Color(hex:"F7E7CE"))
                Text("Evolution is measured not in numbers,\nbut in discipline and mastery.")
                    .font(AppFont.inter(size: 20, weight: .regular))
                    .foregroundStyle(Color(hex:"F7E7CE").opacity(0.6))
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
            }
        }
    }
}

#Preview("Onboarding Flow") {
    let testDefaults = UserDefaults(suiteName: "OnboardingPreviewSuite")!
    testDefaults.removePersistentDomain(forName: "OnboardingPreviewSuite")
    
    let repository = UserDefaultsOnboardingRepository(defaults: testDefaults)
    let viewModel = OnboardingViewModel(repository: repository)
    
    return OnboardingFlowView(
        viewModel: viewModel,
        onFinished: {
            print("Onboarding finished (Preiew)")
        }
    )
}
