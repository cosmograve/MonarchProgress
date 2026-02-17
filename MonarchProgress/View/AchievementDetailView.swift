import SwiftUI

struct AchievementDetailView: View {

    @EnvironmentObject private var store: AppStore
    @Environment(\.dismiss) private var dismiss

    let achievementID: UUID

    private let gold = AppColors.gold
    private let cream = AppColors.cream
    private let bg = AppColors.background
    private let sidePadding: CGFloat = 24

    private var achievement: MPAchievement? {
        store.activeCycle?.achievements.first(where: { $0.id == achievementID })
    }

    var body: some View {
        VStack(spacing: 0) {

            AppNavBar(onBackTap: { dismiss() })

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    Spacer().frame(height: 18)

                    if let a = achievement {
                        detailCard(a)
                            .padding(.horizontal, sidePadding)
                    } else {
                        Text("Not found")
                            .font(AppFont.inter(size: 16, weight: .regular))
                            .foregroundStyle(cream.opacity(0.7))
                            .padding(.horizontal, sidePadding)
                            .padding(.top, 40)
                            .onAppear { dismiss() }
                    }

                    Spacer().frame(height: 120)
                }
            }
        }
        .background(bg.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    // MARK: - Card

    private func detailCard(_ a: MPAchievement) -> some View {
        
        let canEdit = (a.status == .inProgress)
        let canDelete = true

        return VStack(alignment: .leading, spacing: 14) {

            Text(a.title)
                .font(AppFont.inter(size: 24, weight: .medium))
                .foregroundStyle(cream)

            statusPill(a.status)

            Divider()
                .overlay(gold.opacity(0.12))

            section(title: "Description", value: a.details.isEmpty ? "—" : a.details)

            section(title: "Target Date", value: targetDateText(a.targetDate))

            HStack(spacing: 12) {
                editButton(a, enabled: canEdit)
                deleteButton(a, enabled: canDelete)
            }
            .padding(.top, 8)
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

    // MARK: - Pieces

    private func statusPill(_ status: MPAchievementStatus) -> some View {
        Text(statusTitle(status))
            .font(AppFont.inter(size: 12, weight: .regular))
            .foregroundStyle(status == .done ? gold : cream.opacity(0.70))
            .padding(.horizontal, 12)
            .frame(height: 26)
            .background(
                Capsule(style: .continuous)
                    .fill(Color.white.opacity(0.06))
            )
    }

    private func statusTitle(_ status: MPAchievementStatus) -> String {
        switch status {
        case .inProgress: return "In Progress"
        case .done: return "Completed"
        }
    }

    private func targetDateText(_ date: Date?) -> String {
        guard let date else { return "—" }
        return DateFormatter.shortMonDayYear.string(from: date)
    }

    private func section(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(AppFont.inter(size: 12, weight: .regular))
                .foregroundStyle(cream.opacity(0.55))

            Text(value)
                .font(AppFont.inter(size: 14, weight: .regular))
                .foregroundStyle(cream.opacity(0.90))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Buttons

    private func editButton(_ a: MPAchievement, enabled: Bool) -> some View {
        Button {
            store.presentEditAchievement(a)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "pencil")
                    .font(.system(size: 14, weight: .semibold))

                Text("Edit")
                    .font(AppFont.inter(size: 14, weight: .medium))
            }
            .foregroundStyle(enabled ? gold : gold.opacity(0.35))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.white.opacity(0.04))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(gold.opacity(0.22), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }

    private func deleteButton(_ a: MPAchievement, enabled: Bool) -> some View {
        Button {
            store.deleteAchievement(id: a.id)
            dismiss()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "trash")
                    .font(.system(size: 14, weight: .semibold))

                Text("Delete")
                    .font(AppFont.inter(size: 14, weight: .medium))
            }
            .foregroundStyle(enabled ? Color.red.opacity(0.85) : Color.red.opacity(0.35))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.red.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}
