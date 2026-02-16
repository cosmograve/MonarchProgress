import Foundation

protocol MPCycleRepository {
    func getOrCreateActiveCycle() throws -> MPCycle
    func saveActiveCycle(_ cycle: MPCycle) throws
    func fetchArchivedCycles() throws -> [MPCycle]
    func saveArchivedCycles(_ cycles: [MPCycle]) throws
    func archiveActiveAndStartNew() throws -> MPCycle
}


protocol MPAchievementRepository {
    func addAchievement(title: String, details: String, targetDate: Date?, status: MPAchievementStatus) throws -> MPCycle
    func updateAchievement(id: UUID, title: String, details: String, targetDate: Date?, status: MPAchievementStatus) throws -> MPCycle
    func deleteAchievement(id: UUID) throws -> MPCycle
    func setStatus(id: UUID, status: MPAchievementStatus) throws -> MPCycle
}


final class UserDefaultsCycleRepository: MPCycleRepository {

    private let storage: MPUserDefaultsStorage

    private let activeCycleKey = "mp_active_cycle_v1"
    private let archivedCyclesKey = "mp_archived_cycles_v1"

    init(storage: MPUserDefaultsStorage = MPUserDefaultsStorage()) {
        self.storage = storage
    }

    func getOrCreateActiveCycle() throws -> MPCycle {
        if let existing = try storage.getCodable(MPCycle.self, forKey: activeCycleKey) {
            return existing
        }
        let newCycle = MPCycle()
        try saveActiveCycle(newCycle)
        return newCycle
    }

    func saveActiveCycle(_ cycle: MPCycle) throws {
        try storage.setCodable(cycle, forKey: activeCycleKey)
    }

    func fetchArchivedCycles() throws -> [MPCycle] {
        return (try storage.getCodable([MPCycle].self, forKey: archivedCyclesKey)) ?? []
    }

    func saveArchivedCycles(_ cycles: [MPCycle]) throws {
        try storage.setCodable(cycles, forKey: archivedCyclesKey)
    }

    func archiveActiveAndStartNew() throws -> MPCycle {
        var active = try getOrCreateActiveCycle()
        var archived = try fetchArchivedCycles()

        active.archivedAt = Date()
        archived.insert(active, at: 0)
        try saveArchivedCycles(archived)

        let newCycle = MPCycle()
        try saveActiveCycle(newCycle)
        return newCycle
    }
}

final class UserDefaultsAchievementRepository: MPAchievementRepository {

    private let cycleRepo: MPCycleRepository

    init(cycleRepo: MPCycleRepository = UserDefaultsCycleRepository()) {
        self.cycleRepo = cycleRepo
    }

    func addAchievement(title: String, details: String, targetDate: Date?, status: MPAchievementStatus) throws -> MPCycle {
        var cycle = try cycleRepo.getOrCreateActiveCycle()
        let stage = cycle.currentStage

        if cycle.totalCount(in: stage) >= 20 {
            throw MPDomainError.stageLimitReached
        }

        var achievement = MPAchievement(stage: stage, title: title, details: details, status: status, targetDate: targetDate)

        if status == .done {
            achievement.completedAt = Date()
        }

        cycle.achievements.append(achievement)
        try cycleRepo.saveActiveCycle(cycle)
        return cycle
    }

    func updateAchievement(id: UUID, title: String, details: String, targetDate: Date?, status: MPAchievementStatus) throws -> MPCycle {
        var cycle = try cycleRepo.getOrCreateActiveCycle()

        guard let idx = cycle.achievements.firstIndex(where: { $0.id == id }) else {
            throw MPDomainError.achievementNotFound
        }

        guard cycle.achievements[idx].status == .inProgress else {
            throw MPDomainError.cannotEditDone
        }

        cycle.achievements[idx].title = title
        cycle.achievements[idx].details = details
        cycle.achievements[idx].targetDate = targetDate

        cycle.achievements[idx].status = status
        if status == .done {
            cycle.achievements[idx].completedAt = Date()
        } else {
            cycle.achievements[idx].completedAt = nil
        }

        try cycleRepo.saveActiveCycle(cycle)
        return cycle
    }

    func deleteAchievement(id: UUID) throws -> MPCycle {
        var cycle = try cycleRepo.getOrCreateActiveCycle()

        guard let idx = cycle.achievements.firstIndex(where: { $0.id == id }) else {
            throw MPDomainError.achievementNotFound
        }

        guard cycle.achievements[idx].status == .inProgress else {
            throw MPDomainError.cannotDeleteDone
        }

        cycle.achievements.remove(at: idx)

        try cycleRepo.saveActiveCycle(cycle)
        return cycle
    }

    func setStatus(id: UUID, status: MPAchievementStatus) throws -> MPCycle {
        var cycle = try cycleRepo.getOrCreateActiveCycle()

        guard let idx = cycle.achievements.firstIndex(where: { $0.id == id }) else {
            throw MPDomainError.achievementNotFound
        }

        cycle.achievements[idx].status = status

        switch status {
        case .done:
            cycle.achievements[idx].completedAt = Date()
        case .inProgress:
            cycle.achievements[idx].completedAt = nil
        }

        try cycleRepo.saveActiveCycle(cycle)
        return cycle
    }
}
