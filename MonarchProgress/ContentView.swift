import SwiftUI

struct ContentView: View {
    private let onboardingRepository: OnboardingRepository = UserDefaultsOnboardingRepository()
    @State private var shouldShowOnboarding: Bool = true
    
    
    var body: some View {
        Group {
            if shouldShowOnboarding {
                OnboardingFlowView(
                    viewModel: OnboardingViewModel(repository: onboardingRepository),
                    onFinished: {
                        shouldShowOnboarding = false
                    }
                )
            } else {
                MainView()
            }
        }
        .onAppear {
            let completed = onboardingRepository.isOnboardingCompleted()
            shouldShowOnboarding = !completed
        }
    }
}

#Preview {
    ContentView()
}
