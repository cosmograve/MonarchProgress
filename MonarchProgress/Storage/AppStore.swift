import Combine
import SwiftUI

@MainActor
final class AppStore: ObservableObject {

    @Published private(set) var activeCycle: MPCycle?
    @Published private(set) var archivedCycles: [MPCycle] = []


    private let cycleRepo: MPCycleRepository
    private let achievementRepo: MPAchievementRepository
    
    // MARK: - Init
    
    init(cycleRepo: MPCycleRepository? = nil,
         achievementRepo: MPAchievementRepository? = nil) {
        
        let realCycleRepo = cycleRepo ?? UserDefaultsCycleRepository()
        self.cycleRepo = realCycleRepo
        self.achievementRepo = achievementRepo ?? UserDefaultsAchievementRepository(cycleRepo: realCycleRepo)
    }
    
    // MARK: - Load
    
    func load() {
        do {
            activeCycle = try cycleRepo.getOrCreateActiveCycle()
            archivedCycles = try cycleRepo.fetchArchivedCycles()
        } catch {
            print("AppStore load error: \(error)")
        }
    }

    // MARK: - Achievements

    func addAchievement(title: String, details: String, targetDate: Date?, status: MPAchievementStatus) {
        do {
            activeCycle = try achievementRepo.addAchievement(title: title, details: details, targetDate: targetDate, status: status)
        } catch {
            print("Add achievement error: \(error)")
        }
    }

    func updateAchievement(id: UUID, title: String, details: String, targetDate: Date?, status: MPAchievementStatus) {
        do {
            activeCycle = try achievementRepo.updateAchievement(id: id, title: title, details: details, targetDate: targetDate, status: status)
        } catch {
            print("Update achievement error: \(error)")
        }
    }

    func deleteAchievement(id: UUID) {
        do {
            activeCycle = try achievementRepo.deleteAchievement(id: id)
        } catch {
            print("Delete achievement error: \(error)")
        }
    }

    func setStatus(id: UUID, status: MPAchievementStatus) {
        do {
            activeCycle = try achievementRepo.setStatus(id: id, status: status)
        } catch {
            print("Set status error: \(error)")
        }
    }

    // MARK: - Archive

    /// Архивируем цикл и начинаем новый ТОЛЬКО если butterfly 20/20 выполнено
    func archiveIfCompletedAndStartNew() {
        do {
            guard let active = activeCycle else {
                activeCycle = try cycleRepo.getOrCreateActiveCycle()
                return
            }
            guard active.isCompleted else { return }

            let newCycle = try cycleRepo.archiveActiveAndStartNew()
            activeCycle = newCycle
            archivedCycles = try cycleRepo.fetchArchivedCycles()
        } catch {
            print("Archive/start new error: \(error)")
        }
    }
}
