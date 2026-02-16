import SwiftUI

struct OnboardingFlowView: View {

    @StateObject private var viewModel: OnboardingViewModel
    private let onFinished: () -> Void

    init(viewModel: OnboardingViewModel, onFinished: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFinished = onFinished
    }

    var body: some View {
        VStack(spacing: 0) {

            TabView(selection: $viewModel.pageIndex) {
                ForEach(OnboardingPage.allCases) { page in
                    OnboardingPageView(page: page)
                        .tag(page.rawValue)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()

            

            
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {

                AppButton(
                    title: viewModel.buttonTitle,
                    size: .fixed(width: 202, height: 60),
                    shadow: AppButtonShadow(
                        isEnabled: true,
                        radius: 20,
                        x: 0,
                        y: 10,
                        opacity: 0.001
                    )
                ) {
                    viewModel.primaryTapped(onFinished: onFinished)
                }

                OnboardingPageIndicatorMG(
                    total: viewModel.totalPages,
                    currentIndex: $viewModel.pageIndex
                )
            }
            .padding(.bottom, 16)
            .padding(.top, 8)
            .frame(maxWidth: .infinity)
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
            print("Onboarding finished (Preview)")
        }
    )
}
