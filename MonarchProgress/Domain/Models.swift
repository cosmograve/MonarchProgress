import Foundation


enum MPStage: Int, CaseIterable, Codable, Comparable {
    case caterpillar = 0
    case chrysalis = 1
    case butterfly = 2

    static func < (lhs: MPStage, rhs: MPStage) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var title: String {
        switch self {
        case .caterpillar: return "Caterpillar"
        case .chrysalis: return "Chrysalis"
        case .butterfly: return "Butterfly"
        }
    }
}


enum MPAchievementStatus: String, CaseIterable, Codable {
    case inProgress
    case done
}


struct MPAchievement: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    
    var stage: MPStage
    
    var title: String
    var details: String
    
    var status: MPAchievementStatus
    
    var completedAt: Date?
    
    var createdAt: Date
    
    var targetDate: Date?
    
    init(
        id: UUID = UUID(),
        stage: MPStage,
        title: String,
        details: String,
        status: MPAchievementStatus = .inProgress,
        targetDate: Date? = nil,
        completedAt: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.stage = stage
        self.title = title
        self.details = details
        self.status = status
        self.targetDate = targetDate
        self.completedAt = completedAt
        self.createdAt = createdAt
    }
}

struct MPCycle: Identifiable, Codable, Equatable {
    let id: UUID

    var startedAt: Date
    var archivedAt: Date?

    var achievements: [MPAchievement]

    init(
        id: UUID = UUID(),
        startedAt: Date = Date(),
        archivedAt: Date? = nil,
        achievements: [MPAchievement] = []
    ) {
        self.id = id
        self.startedAt = startedAt
        self.archivedAt = archivedAt
        self.achievements = achievements
    }

    var isActive: Bool { archivedAt == nil }

    func achievements(in stage: MPStage) -> [MPAchievement] {
        achievements.filter { $0.stage == stage }
    }

    func doneCount(in stage: MPStage) -> Int {
        achievements.filter { $0.stage == stage && $0.status == .done }.count
    }

    func totalCount(in stage: MPStage) -> Int {
        achievements.filter { $0.stage == stage }.count
    }

    var currentStage: MPStage {
        if doneCount(in: .caterpillar) < 20 { return .caterpillar }
        if doneCount(in: .chrysalis) < 20 { return .chrysalis }
        return .butterfly
    }

    var isCompleted: Bool {
        doneCount(in: .butterfly) >= 20
    }
}
