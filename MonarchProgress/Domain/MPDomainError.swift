import Foundation

enum MPDomainError: LocalizedError {
    case noActiveCycle
    case stageLocked
    case stageLimitReached
    case cannotEditDone
    case cannotDeleteDone
    case achievementNotFound

    var errorDescription: String? {
        switch self {
        case .noActiveCycle:
            return "No active cycle."
        case .stageLocked:
            return "This stage is locked."
        case .stageLimitReached:
            return "Maximum 20 achievements per stage."
        case .cannotEditDone:
            return "Done achievements cannot be edited."
        case .cannotDeleteDone:
            return "Done achievements cannot be deleted."
        case .achievementNotFound:
            return "Achievement not found."
        }
    }
}
