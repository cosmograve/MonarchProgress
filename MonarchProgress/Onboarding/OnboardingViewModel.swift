import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {

    @Published var pageIndex: Int = 0

    private let repository: OnboardingRepository

    init(repository: OnboardingRepository) {
        self.repository = repository
    }

    var totalPages: Int {
        OnboardingPage.allCases.count
    }

    var isLastPage: Bool {
        pageIndex == totalPages - 1
    }

    var buttonTitle: String {
        isLastPage ? "Begin" : "Continue"
    }

    func primaryTapped(onFinished: () -> Void) {
        if isLastPage {
            repository.setOnboardingCompleted(true)
            onFinished()
        } else {
            pageIndex += 1
        }
    }

    var currentPage: OnboardingPage {
        OnboardingPage(rawValue: pageIndex) ?? .page1
    }
}
