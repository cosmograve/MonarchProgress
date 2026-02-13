import Foundation

protocol OnboardingRepository {
    func isOnboardingCompleted() -> Bool

    func setOnboardingCompleted(_ completed: Bool)
}

final class UserDefaultsOnboardingRepository: OnboardingRepository {

    private let completedKey = "monarch_progress_onboarding_completed"
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func isOnboardingCompleted() -> Bool {
        defaults.bool(forKey: completedKey)
    }

    func setOnboardingCompleted(_ completed: Bool) {
        defaults.set(completed, forKey: completedKey)
    }
}
