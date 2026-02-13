import SwiftUI

struct OnboardingPage1View: View {
    var body: some View {
        ZStack {
            Image(.onboarding1)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
                .padding(-40)
            VStack {
                Image(.onboarding1Logo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.1)
                Text("A private system for personal evolution.")
                    .foregroundStyle(Color(hex: "F7E7CE").opacity(0.7))
                    .font(AppFont.inter(size: 20, weight: .regular))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
                
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
