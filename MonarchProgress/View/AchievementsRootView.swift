import SwiftUI

struct AchievementsRootView: View {

    @EnvironmentObject private var store: AppStore

    // MARK: - UI State

    @State private var filter: AchievementFilter = .all
    @State private var showAddOverlay: Bool = false

    // MARK: - Constants

    private let sidePadding: CGFloat = 24
    private let gold = AppColors.gold
    private let cream = AppColors.cream
    private let bg = AppColors.background

    // MARK: - Derived

    private var stage: MPStage {
        store.activeCycle?.currentStage ?? .caterpillar
    }

    private var stageSubtitle: String {
        switch stage {
        case .caterpillar: return "Caterpillar Stage"
        case .chrysalis: return "Chrysalis Stage"
        case .butterfly: return "Butterfly Stage"
        }
    }

    private var allAchievements: [MPAchievement] {
        (store.activeCycle?.achievements ?? [])
            .filter { $0.stage == stage }
            .sorted { $0.createdAt > $1.createdAt }
    }

    private var filteredAchievements: [MPAchievement] {
        switch filter {
        case .all:
            return allAchievements
        case .completed:
            return allAchievements.filter { $0.status == .done }
        case .inProgress:
            return allAchievements.filter { $0.status == .inProgress }
        }
    }

    var body: some View {
        VStack(spacing: 0) {

            AppNavBar(onBackTap: nil)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Achievements")
                                .font(AppFont.inter(size: 24, weight: .medium))
                                .foregroundStyle(cream)

                            Text(stageSubtitle)
                                .font(AppFont.inter(size: 16, weight: .regular))
                                .foregroundStyle(cream.opacity(0.55))
                        }

                        Spacer()

                        AddAchievementButton {
                            
                            showAddOverlay = true
                        }
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 18)

                    HStack(spacing: 14) {
                        Image("ic_filter")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)

                        FilterChipGroup(
                            selected: $filter,
                            gold: gold,
                            cream: cream
                        )
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 18)

                    VStack(spacing: 16) {
                        ForEach(filteredAchievements) { achievement in
                            AchievementCardView(
                                achievement: achievement,
                                gold: gold,
                                cream: cream
                            )
                            .onTapGesture {
                                let next: MPAchievementStatus = (achievement.status == .done) ? .inProgress : .done
                                store.setStatus(id: achievement.id, status: next)
                            }
                        }
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 16)

                    Spacer().frame(height: 120)
                }
            }
        }
        .background(bg.ignoresSafeArea())
        .overlay {
            if showAddOverlay {
                AchievementEditorOverlay(
                    isPresented: $showAddOverlay,
                    mode: .create
                )
            }
        }
    }
}

private enum AchievementFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case completed = "Completed"
    case inProgress = "In Progress"
    
    var id: String { rawValue }
}


private struct AddAchievementButton: View {
    
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .semibold))

                Text("Add Achievement")
                    .font(AppFont.inter(size: 16, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundStyle(Color(hex: "1A0F0A"))
            .padding(.horizontal, 16)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "D4AF37"))
            )
            .shadow(color: Color(hex: "D4AF37").opacity(0.25), radius: 16, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Filter chips

private struct FilterChipGroup: View {

    @Binding var selected: AchievementFilter

    let gold: Color
    let cream: Color

    var body: some View {
        HStack(spacing: 12) {
            chip(.all)
            chip(.completed)
            chip(.inProgress)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func chip(_ item: AchievementFilter) -> some View {
        let isSelected = (selected == item)

        return Button {
            selected = item
        } label: {
            Text(item.rawValue)
                .font(AppFont.inter(size: 14, weight: .regular))
                .lineLimit(1)
                .foregroundStyle(isSelected ? Color(hex: "1A0F0A") : cream.opacity(0.65))
                .padding(.horizontal, 16)
                .frame(height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? gold : Color.white.opacity(0.06))
                )
        }
        .buttonStyle(.plain)
    }
}

private struct AchievementCardView: View {

    let achievement: MPAchievement
    let gold: Color
    let cream: Color

    private var statusTitle: String {
        switch achievement.status {
        case .inProgress: return "In Progress"
        case .done: return "Completed"
        }
    }

    private var iconAsset: String {
        
        switch achievement.status {
        case .inProgress: return "ic_status_clock"
        case .done: return "ic_status_check"
        }
    }

    private var dateText: String {
        let date = (achievement.status == .done ? achievement.completedAt : achievement.createdAt) ?? achievement.createdAt
        return DateFormatter.shortMonDayYear.string(from: date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(iconAsset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 26, height: 26)
                .foregroundStyle(gold)

            VStack(alignment: .leading, spacing: 8) {

                Text(achievement.title)
                    .font(AppFont.inter(size: 22, weight: .medium))
                    .foregroundStyle(cream)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                if !achievement.details.isEmpty {
                    Text(achievement.details)
                        .font(AppFont.inter(size: 16, weight: .regular))
                        .foregroundStyle(cream.opacity(0.55))
                        .lineLimit(2)
                }

                Text(dateText)
                    .font(AppFont.inter(size: 14, weight: .regular))
                    .foregroundStyle(gold.opacity(0.85))
            }

            Spacer(minLength: 12)

            VStack {
                Spacer()

                Text(statusTitle)
                    .font(AppFont.inter(size: 14, weight: .regular))
                    .foregroundStyle(achievement.status == .done ? gold : cream.opacity(0.65))
                    .padding(.horizontal, 14)
                    .frame(height: 32)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.white.opacity(0.06))
                    )
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(gold.opacity(0.22), lineWidth: 1)
        )
    }
}

extension DateFormatter {
    static let shortMonDayYear: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "MMM d, yyyy"
        return f
    }()
}

#Preview {
    AchievementsRootView()
        .environmentObject(AppStore())
}
