import SwiftUI

struct ArchiveRootView: View {

    @EnvironmentObject private var store: AppStore

    private let bg = AppColors.background
    private let gold = AppColors.gold
    private let cream = AppColors.cream

    private let sidePadding: CGFloat = 24
    private let gridSpacing: CGFloat = 14
    private let previewCardHeight: CGFloat = 180

    private var archived: [MPCycle] { store.archivedCycles }
    private var active: MPCycle? { store.activeCycle }
    private var isEmptyArchive: Bool { archived.isEmpty }

    private var caterpillarDone: Int { active?.doneCount(in: .caterpillar) ?? 0 }
    private var chrysalisDone: Int { active?.doneCount(in: .chrysalis) ?? 0 }
    private var butterflyDone: Int { active?.doneCount(in: .butterfly) ?? 0 }

    var body: some View {
        VStack(spacing: 0) {

            AppNavBar(onBackTap: nil)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    headerBlock()
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 18)

                    completedCyclesBlock()
                        .padding(.top, 18)

                    Text("All cycles")
                        .font(AppFont.inter(size: 16, weight: .regular))
                        .foregroundStyle(cream.opacity(0.55))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 34)

                    allCyclesPreview()
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 18)

                    Spacer().frame(height: 120)
                }
            }
        }
        .background(bg.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }

    private func headerBlock() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Archive")
                .font(AppFont.inter(size: 28, weight: .medium))
                .foregroundStyle(cream)

            Text("Your completed transformation cycles")
                .font(AppFont.inter(size: 16, weight: .regular))
                .foregroundStyle(cream.opacity(0.55))
        }
    }

    private func completedCyclesBlock() -> some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("Completed cycles")
                .font(AppFont.inter(size: 18, weight: .medium))
                .foregroundStyle(cream)
                .padding(.horizontal, sidePadding)

            if isEmptyArchive {
                emptyState()
                    .padding(.top, 18)
                    .padding(.horizontal, sidePadding)
            } else {
                VStack(spacing: 14) {
                    ForEach(archived) { cycle in
                        NavigationLink {
                            ArchiveCycleDetailView(cycle: cycle)
                        } label: {
                            ArchiveCompletedCycleRow(cycle: cycle)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, sidePadding)
                .padding(.top, 18)
            }
        }
    }

    private func emptyState() -> some View {
        VStack(spacing: 14) {

            ZStack {
                Circle()
                    .fill(gold.opacity(0.10))
                    .frame(width: 64, height: 64)

                Image("ic_archive_empty")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .foregroundStyle(gold)
            }

            Text("No completed cycles yet")
                .font(AppFont.inter(size: 16, weight: .medium))
                .foregroundStyle(cream.opacity(0.85))

            Text("Complete all 60 achievements to archive your first cycle")
                .font(AppFont.inter(size: 14, weight: .regular))
                .foregroundStyle(cream.opacity(0.45))
                .multilineTextAlignment(.center)
                .frame(maxWidth: 280)
        }
        .frame(maxWidth: .infinity)
    }

    private func allCyclesPreview() -> some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let itemWidth = (totalWidth - gridSpacing) / 2

            VStack(spacing: gridSpacing) {

                HStack(spacing: gridSpacing) {
                    ArchiveStagePreviewCard(
                        stage: .caterpillar,
                        filledCount: caterpillarDone,
                        subtitle: "\(caterpillarDone) of 20 achievements",
                        cardHeight: previewCardHeight
                    )
                    .frame(width: itemWidth)

                    ArchiveStagePreviewCard(
                        stage: .chrysalis,
                        filledCount: chrysalisDone,
                        subtitle: "\(chrysalisDone) of 20 achievements",
                        cardHeight: previewCardHeight
                    )
                    .frame(width: itemWidth)
                }

                ArchiveStagePreviewCard(
                    stage: .butterfly,
                    filledCount: butterflyDone,
                    subtitle: "\(butterflyDone) of 20 achievements",
                    cardHeight: previewCardHeight
                )
                .frame(width: itemWidth)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(width: totalWidth)
        }
        .frame(height: previewCardHeight * 2 + gridSpacing)
    }
}

private struct ArchiveCompletedCycleRow: View {

    let cycle: MPCycle

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    private var doneCount: Int { cycle.achievements.filter { $0.status == .done }.count }
    private var subtitle: String { "\(doneCount) of 60 achievements" }

    var body: some View {
        HStack(spacing: 14) {

            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(gold.opacity(0.10))
                    .frame(width: 54, height: 54)

                Image("ic_archive_cycle")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundStyle(gold)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Cycle completed")
                    .font(AppFont.inter(size: 16, weight: .medium))
                    .foregroundStyle(cream)

                Text(subtitle)
                    .font(AppFont.inter(size: 14, weight: .regular))
                    .foregroundStyle(cream.opacity(0.55))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(cream.opacity(0.35))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(gold.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct ArchiveStagePreviewCard: View {

    let stage: MPStage
    let filledCount: Int
    let subtitle: String
    let cardHeight: CGFloat

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        VStack(spacing: 10) {

            Spacer(minLength: 0)

            stageArt()
                .frame(maxWidth: .infinity)
                .frame(height: 112)

            Spacer(minLength: 0)

            Text(subtitle)
                .font(AppFont.inter(size: 12, weight: .regular))
                .foregroundStyle(cream.opacity(0.45))
                .padding(.bottom, 2)
        }
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(gold.opacity(0.18), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func stageArt() -> some View {
        switch stage {
        case .caterpillar:
            MPCaterpillarPreviewView(
                filledCount: filledCount,
                gold: gold,
                cream: cream
            )

        case .chrysalis:
            MPChrysalisPreviewView(
                assetName: "home_stage_chrysalis_art",
                filledCount: filledCount,
                gold: gold,
                cream: cream
            )

        case .butterfly:
            MPButterflyPreviewView(
                assetName: "home_stage_butterfly_art",
                filledCount: filledCount,
                gold: gold,
                cream: cream,
                wingSpread: 0.22,
                markerSize: 12
            )
        }
    }
}

private struct MPCaterpillarPreviewView: View {

    let filledCount: Int
    let gold: Color
    let cream: Color

    var body: some View {
        VStack(spacing: 8) {
            Image("home_stage_caterpillar")
                .resizable()
                .scaledToFit()
                .frame(height: 28)

            ProgressDots20View(
                filledCount: filledCount,
                circleSize: 16,
                strokeWidth: 1.1,
                strokeColor: gold.opacity(0.35),
                fillColor: gold,
                numberColor: cream,
                spacing: 6,
                rowSpacing: 6,
                selectedIndex: nil
            )
        }
        .frame(maxWidth: .infinity)
    }
}

private struct MPChrysalisPreviewView: View {

    let assetName: String
    let filledCount: Int
    let gold: Color
    let cream: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: w, height: h)

                MPDiamondGrid20View(
                    filledCount: filledCount,
                    diamondSize: max(10, w * 0.070),
                    strokeWidth: 1.0,
                    hSpacing: max(5, w * 0.018),
                    vSpacing: max(5, w * 0.018),
                    gold: gold,
                    cream: cream
                )
                .frame(width: w * 0.52, height: h * 0.66)
                .position(x: w * 0.56, y: h * 0.52)
            }
            .frame(width: w, height: h)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct MPButterflyPreviewView: View {

    let assetName: String
    let filledCount: Int
    let gold: Color
    let cream: Color
    let wingSpread: CGFloat
    let markerSize: CGFloat

    private let strokeWidth: CGFloat = 1.0

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            ZStack {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)

                ForEach(0..<min(MPButterflyPositions.normalized.count, 20), id: \.self) { i in
                    let p0 = MPButterflyPositions.normalized[i]
                    let p = spread(p0, amount: wingSpread)

                    let x = p.x * size.width
                    let y = p.y * size.height
                    let isFilled = i < max(0, min(20, filledCount))

                    ZStack {
                        Circle()
                            .fill(isFilled ? gold.opacity(0.55) : Color.clear)

                        Circle()
                            .stroke(gold.opacity(0.90), lineWidth: strokeWidth)

                        Text("\(i + 1)")
                            .font(AppFont.inter(size: max(7, markerSize * 0.50), weight: .medium))
                            .foregroundStyle(cream.opacity(isFilled ? 0.95 : 0.40))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .allowsTightening(true)
                    }
                    .frame(width: markerSize, height: markerSize)
                    .position(x: x, y: y)
                }
            }
            .frame(width: size.width, height: size.height)
        }
    }

    private func spread(_ p: CGPoint, amount: CGFloat) -> CGPoint {
        let cx: CGFloat = 0.5
        if p.x < cx {
            return CGPoint(x: max(0, p.x - amount), y: p.y)
        } else {
            return CGPoint(x: min(1, p.x + amount), y: p.y)
        }
    }
}

private enum MPButterflyPositions {

    static let normalized: [CGPoint] = [
        // LEFT wing
        CGPoint(x: 0.28, y: 0.33), CGPoint(x: 0.42, y: 0.33),
        CGPoint(x: 0.28, y: 0.43), CGPoint(x: 0.42, y: 0.43),
        CGPoint(x: 0.28, y: 0.53), CGPoint(x: 0.42, y: 0.53),
        CGPoint(x: 0.28, y: 0.63), CGPoint(x: 0.42, y: 0.63),
        CGPoint(x: 0.28, y: 0.73), CGPoint(x: 0.42, y: 0.73),

        // RIGHT wing
        CGPoint(x: 0.58, y: 0.33), CGPoint(x: 0.72, y: 0.33),
        CGPoint(x: 0.58, y: 0.43), CGPoint(x: 0.72, y: 0.43),
        CGPoint(x: 0.58, y: 0.53), CGPoint(x: 0.72, y: 0.53),
        CGPoint(x: 0.58, y: 0.63), CGPoint(x: 0.72, y: 0.63),
        CGPoint(x: 0.58, y: 0.73), CGPoint(x: 0.72, y: 0.73)
    ]
}


private struct MPDiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.closeSubpath()
        return p
    }
}

private struct MPDiamondGrid20View: View {

    let filledCount: Int
    let diamondSize: CGFloat
    let strokeWidth: CGFloat
    let hSpacing: CGFloat
    let vSpacing: CGFloat
    let gold: Color
    let cream: Color

    var body: some View {
        let columns: [GridItem] = Array(
            repeating: GridItem(.fixed(diamondSize), spacing: hSpacing, alignment: .center),
            count: 4
        )

        LazyVGrid(columns: columns, alignment: .center, spacing: vSpacing) {
            ForEach(0..<20, id: \.self) { idx in
                diamond(index: idx)
                    .frame(width: diamondSize, height: diamondSize)
            }
        }
    }

    private func diamond(index: Int) -> some View {
        let isFilled = index < max(0, min(20, filledCount))

        return ZStack {
            MPDiamondShape()
                .fill(isFilled ? gold.opacity(0.60) : Color.clear)

            MPDiamondShape()
                .stroke(gold.opacity(0.95), lineWidth: strokeWidth)

            Text("\(index + 1)")
                .font(AppFont.inter(size: 8, weight: .medium))
                .foregroundStyle(cream.opacity(isFilled ? 0.95 : 0.40))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

struct ArchiveCycleDetailView: View {

    let cycle: MPCycle

    private let bg = AppColors.background
    private let gold = AppColors.gold
    private let cream = AppColors.cream
    private let sidePadding: CGFloat = 24

    private var sortedAchievements: [MPAchievement] {
        cycle.achievements.sorted { $0.createdAt > $1.createdAt }
    }

    private var caterpillarDone: Int { cycle.doneCount(in: .caterpillar) }
    private var chrysalisDone: Int { cycle.doneCount(in: .chrysalis) }
    private var butterflyDone: Int { cycle.doneCount(in: .butterfly) }

    var body: some View {
        VStack(spacing: 0) {

            AppNavBar(onBackTap: nil)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    Text("Cycle")
                        .font(AppFont.inter(size: 24, weight: .medium))
                        .foregroundStyle(cream)
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 18)

                    Text("All stages")
                        .font(AppFont.inter(size: 14, weight: .regular))
                        .foregroundStyle(cream.opacity(0.55))
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 6)

                    VStack(spacing: 14) {

                        ArchiveStageDetailCard(
                            title: "Caterpillar",
                            subtitle: "\(caterpillarDone) of 20 achievements",
                            content: AnyView(
                                VStack(spacing: 12) {
                                    Image("home_stage_caterpillar")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 76)

                                    ProgressDots20View(
                                        filledCount: caterpillarDone,
                                        circleSize: 26,
                                        strokeWidth: 1.6,
                                        strokeColor: gold.opacity(0.35),
                                        fillColor: gold,
                                        numberColor: cream,
                                        spacing: 10,
                                        rowSpacing: 10,
                                        selectedIndex: nil
                                    )
                                }
                            )
                        )

                        ArchiveStageDetailCard(
                            title: "Chrysalis",
                            subtitle: "\(chrysalisDone) of 20 achievements",
                            content: AnyView(
                                MPChrysalisPreviewView(
                                    assetName: "home_stage_chrysalis_art",
                                    filledCount: chrysalisDone,
                                    gold: gold,
                                    cream: cream
                                )
                                .frame(height: 220)
                            )
                        )

                        ArchiveStageDetailCard(
                            title: "Butterfly",
                            subtitle: "\(butterflyDone) of 20 achievements",
                            content: AnyView(
                                MPButterflyPreviewView(
                                    assetName: "home_stage_butterfly_art",
                                    filledCount: butterflyDone,
                                    gold: gold,
                                    cream: cream,
                                    wingSpread: 0.18,
                                    markerSize: 20
                                )
                                .frame(height: 200)
                            )
                        )
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 18)

                    Text("Achievements")
                        .font(AppFont.inter(size: 18, weight: .medium))
                        .foregroundStyle(cream)
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 26)

                    VStack(spacing: 12) {
                        ForEach(sortedAchievements) { a in
                            ArchiveAchievementRow(achievement: a)
                        }
                    }
                    .padding(.horizontal, sidePadding)
                    .padding(.top, 12)

                    Spacer().frame(height: 120)
                }
            }
        }
        .background(bg.ignoresSafeArea())
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct ArchiveStageDetailCard: View {

    let title: String
    let subtitle: String
    let content: AnyView

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppFont.inter(size: 16, weight: .medium))
                .foregroundStyle(cream.opacity(0.85))

            Text(subtitle)
                .font(AppFont.inter(size: 13, weight: .regular))
                .foregroundStyle(cream.opacity(0.50))

            content
                .frame(maxWidth: .infinity)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(gold.opacity(0.18), lineWidth: 1)
        )
    }
}

private struct ArchiveAchievementRow: View {

    let achievement: MPAchievement

    private let gold = AppColors.gold
    private let cream = AppColors.cream

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
        let date = achievement.targetDate ?? achievement.createdAt
        return DateFormatter.shortMonDayYear.string(from: date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {

            Image(iconAsset)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundStyle(gold)

            VStack(alignment: .leading, spacing: 6) {
                Text(achievement.title)
                    .font(AppFont.inter(size: 16, weight: .medium))
                    .foregroundStyle(cream)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)

                if !achievement.details.isEmpty {
                    Text(achievement.details)
                        .font(AppFont.inter(size: 14, weight: .regular))
                        .foregroundStyle(cream.opacity(0.55))
                        .lineLimit(2)
                }

                Text(dateText)
                    .font(AppFont.inter(size: 12, weight: .regular))
                    .foregroundStyle(gold.opacity(0.80))
            }

            Spacer(minLength: 12)

            Text(statusTitle)
                .font(AppFont.inter(size: 12, weight: .regular))
                .foregroundStyle(achievement.status == .done ? gold : cream.opacity(0.65))
                .padding(.horizontal, 12)
                .frame(height: 28)
                .background(
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.06))
                )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(gold.opacity(0.14), lineWidth: 1)
        )
    }
}
