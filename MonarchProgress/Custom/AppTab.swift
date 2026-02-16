import SwiftUI

enum AppTab: CaseIterable, Identifiable {
    case home
    case achievements
    case archive

    var id: String {
        switch self {
        case .home: return "home"
        case .achievements: return "achievements"
        case .archive: return "archive"
        }
    }

    var title: String {
        switch self {
        case .home: return "Home"
        case .achievements: return "Achievements"
        case .archive: return "Archive"
        }
    }

    var iconAssetName: String {
        switch self {
        case .home: return "tab_home"
        case .achievements: return "tab_achievements"
        case .archive: return "tab_archive"
        }
    }
}





