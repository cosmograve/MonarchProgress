import SwiftUI


struct HomeRootView: View {

    @EnvironmentObject private var store: AppStore
    var onOpenAchievements: (() -> Void)? = nil
    var onOpenArchive: (() -> Void)? = nil

    private let sidePadding: CGFloat = 24
    private let topSpacing: CGFloat = 18

    private let capsuleHeight: CGFloat = 44
    private let capsuleHorizontalPadding: CGFloat = 18

    private let circleSize: CGFloat = 44
    private let circleStrokeWidth: CGFloat = 2
    private let circleSpacing: CGFloat = 14
    private let rowSpacing: CGFloat = 16

    
    private var stage: MPStage {
        store.activeCycle?.currentStage ?? .caterpillar
    }

    private var doneCount: Int {
        store.activeCycle?.doneCount(in: stage) ?? 0
    }

    private var stageCapsuleTitle: String {
        switch stage {
        case .caterpillar:
            return "FOUNDATION & ACTION"
        case .chrysalis:
            return "INTERNAL TRANSFORMATION"
        case .butterfly:
            return "ACHIEVEMENT & MASTERY"
        }
    }

    private var stageTitle: String {
        switch stage {
        case .caterpillar: return "Caterpillar"
        case .chrysalis: return "Chrysalis"
        case .butterfly: return "Butterfly"
        }
    }

    private var stageImageAsset: String {
        switch stage {
        case .caterpillar: return "home_stage_caterpillar"
        case .chrysalis: return "home_stage_chrysalis"
        case .butterfly: return "home_stage_butterfly"
        }
    }

    private let bg = AppColors.background
    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        VStack(spacing: 0) {

            AppNavBar(onBackTap: nil)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    Spacer().frame(height: topSpacing)

                    StageCapsuleView(
                        title: stageCapsuleTitle,
                        textColor: gold,
                        strokeColor: gold.opacity(0.35),
                        fillColor: gold.opacity(0.10),
                        height: capsuleHeight,
                        horizontalPadding: capsuleHorizontalPadding
                    )
                    .padding(.horizontal, sidePadding)

                    Spacer().frame(height: 18)

                    Text(stageTitle)
                        .font(AppFont.inter(size: 36, weight: .medium))
                        .foregroundStyle(cream)
                        .frame(maxWidth: .infinity, alignment: .center)

                    Spacer().frame(height: 10)

                    VStack(spacing: 0) {
                        Text("\(doneCount) /\n20")
                            .font(AppFont.inter(size: 18, weight: .regular))
                            .foregroundStyle(cream.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .lineSpacing(0)
                            .frame(maxWidth: .infinity)
                        
                    }
                    .frame(maxWidth: .infinity)

                    Spacer().frame(height: 18)

                    Image(stageImageAsset)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 86)

                    Spacer().frame(height: 22)

                    ProgressDots20View(
                        filledCount: doneCount,
                        circleSize: 44,
                        strokeWidth: 2,
                        strokeColor: AppColors.gold.opacity(0.35),
                        fillColor: AppColors.gold,
                        numberColor: AppColors.cream,
                        spacing: 14,
                        rowSpacing: 16,
                        selectedIndex: nil
                    )
                    .padding(.horizontal, sidePadding)

                    Spacer().frame(height: 26)

                    Spacer().frame(height: 120)
                }
            }
        }
        .background(
            ZStack {
                bg.ignoresSafeArea()
                
            }
        )
    }
}

#Preview {
    HomeRootView()
        .environmentObject(AppStore())
}

struct StageCapsuleView: View {

    let title: String
    let textColor: Color
    let strokeColor: Color
    let fillColor: Color

    let height: CGFloat
    let horizontalPadding: CGFloat

    var body: some View {
        Text(title)
            .font(AppFont.inter(size: 14, weight: .medium))
            .foregroundStyle(textColor)
            .padding(.horizontal, horizontalPadding)
            .frame(height: height)
            .background(
                Capsule(style: .continuous)
                    .fill(fillColor)
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(strokeColor, lineWidth: 1)
            )
            .frame(maxWidth: .infinity, alignment: .center)
    }
}


struct ProgressDots20View: View {

    let filledCount: Int

    let circleSize: CGFloat

    let strokeWidth: CGFloat

    let strokeColor: Color

    let fillColor: Color

    let numberColor: Color

    let spacing: CGFloat

    let rowSpacing: CGFloat

    
    let selectedIndex: Int?
    let selectedStrokeColor: Color

    init(
        filledCount: Int,
        circleSize: CGFloat = 44,
        strokeWidth: CGFloat = 2,
        strokeColor: Color,
        fillColor: Color,
        numberColor: Color,
        spacing: CGFloat = 14,
        rowSpacing: CGFloat = 16,
        selectedIndex: Int? = nil,
        selectedStrokeColor: Color = .blue
    ) {
        self.filledCount = max(0, min(20, filledCount))
        self.circleSize = circleSize
        self.strokeWidth = strokeWidth
        self.strokeColor = strokeColor
        self.fillColor = fillColor
        self.numberColor = numberColor
        self.spacing = spacing
        self.rowSpacing = rowSpacing
        self.selectedIndex = selectedIndex
        self.selectedStrokeColor = selectedStrokeColor
    }

    var body: some View {
        VStack(spacing: rowSpacing) {
            dotsRow(startIndex: 0, count: 6)
            dotsRow(startIndex: 6, count: 6)
            dotsRow(startIndex: 12, count: 6)

            HStack(spacing: spacing) {
                dot(index: 18)
                dot(index: 19)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Row

    private func dotsRow(startIndex: Int, count: Int) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<count, id: \.self) { offset in
                dot(index: startIndex + offset)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Dot

    private func dot(index: Int) -> some View {
        let isFilled = index < filledCount
        let isSelected = (selectedIndex == index)

        let stroke = isSelected ? selectedStrokeColor : strokeColor

        return ZStack {
            // Форма
            Circle()
                .fill(isFilled ? fillColor.opacity(0.16) : Color.clear)

            Circle()
                .stroke(stroke, lineWidth: strokeWidth)

            // Номер
            Text("\(index + 1)")
                .font(AppFont.inter(size: 16, weight: .regular))
                .foregroundStyle(isFilled ? numberColor : .clear)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(width: circleSize, height: circleSize)
        // Очень мягкое свечение только для заполненных (можешь убрать вообще)
        .shadow(color: isFilled ? fillColor.opacity(0.18) : .clear, radius: 6, x: 0, y: 2)
    }
}


