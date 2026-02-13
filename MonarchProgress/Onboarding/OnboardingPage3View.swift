import SwiftUI

struct OnboardingPage3View: View {
    var body: some View {
        ZStack {
            Color(hex: "1A0F0A")
                .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 18) {

                    Image(.stage1)

                    Text("Caterpillar")
                        .font(AppFont.inter(size: 36, weight: .medium))
                        .foregroundStyle(Color(hex:"F7E7CE"))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    Text("Each achievement fills one segment.\nAction builds the foundation.")
                        .font(AppFont.inter(size: 20, weight: .regular))
                        .foregroundStyle(Color(hex:"F7E7CE").opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    Image(.onbSt1)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 110) 
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
