import SwiftUI

struct OnboardingPage2View: View {

    var body: some View {
        ZStack {
            Color(hex: "1A0F0A")
                .ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 18) {

                    Text("The Journey")
                        .font(AppFont.inter(size: 36, weight: .medium))
                        .foregroundStyle(Color(hex:"F7E7CE"))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    Text("Progress unfolds in stages\nEach stage reveals the next version of you.")
                        .font(AppFont.inter(size: 20, weight: .regular))
                        .foregroundStyle(Color(hex:"F7E7CE").opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .center, spacing: 14) {
                        StageBlockView(
                            stageTitle: "Stage one",
                            name: "Caterpillar",
                            description: "Foundation & Action",
                            imageName: .st1
                        )

                        StageBlockView(
                            stageTitle: "Stage two",
                            name: "Chrysalis",
                            description: "Internal Transformation",
                            imageName: .st2
                        )

                        StageBlockView(
                            stageTitle: "Stage three",
                            name: "Butterfly",
                            description: "Achievement & Mastery",
                            imageName: .st3
                        )
                    }

                    Spacer().frame(height: 110)
                }
                .padding(.horizontal, 32)   // ✅ вот здесь 32
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

private struct StageBlockView: View {

    let stageTitle: String
    let name: String
    let description: String
    let imageName: ImageResource

    var body: some View {
        VStack(alignment: .center, spacing: 6) {

            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.top, 6)
            
            Text(stageTitle)
                .font(AppFont.inter(size: 16, weight: .regular))
                .foregroundStyle(Color(hex: "D4AF37"))

            Text(name)
                .font(AppFont.inter(size: 18, weight: .regular))
                .foregroundStyle(Color(hex: "F7E7CE"))

            Text(description)
                .font(AppFont.inter(size: 14, weight: .regular))
                .foregroundStyle(Color(hex: "F7E7CE").opacity(0.5))

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
