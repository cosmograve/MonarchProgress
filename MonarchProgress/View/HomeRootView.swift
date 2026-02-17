import SwiftUI

struct HomeRootView: View {

    @EnvironmentObject private var store: AppStore

    private let sidePadding: CGFloat = 24
    private let topSpacing: CGFloat = 18

    private let capsuleHeight: CGFloat = 44
    private let capsuleHorizontalPadding: CGFloat = 18

    private var stage: MPStage {
        store.activeCycle?.currentStage ?? .caterpillar
    }

    private var doneCount: Int {
        store.activeCycle?.doneCount(in: stage) ?? 0
    }

    private var stageCapsuleTitle: String {
        switch stage {
        case .caterpillar: return "FOUNDATION & ACTION"
        case .chrysalis: return "INTERNAL TRANSFORMATION"
        case .butterfly: return "ACHIEVEMENT & MASTERY"
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

                    Text("\(doneCount) /\n20")
                        .font(AppFont.inter(size: 18, weight: .regular))
                        .foregroundStyle(cream.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(0)
                        .frame(maxWidth: .infinity)

                    Spacer().frame(height: 18)

                    if stage == .caterpillar {
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
                    } else {
                        StageProgressArtView(
                            stage: stage,
                            filledCount: doneCount,
                            chrysalisAssetName: "home_stage_chrysalis_art",
                            butterflyAssetName: "home_stage_butterfly_art",
                            gold: gold,
                            cream: cream
                        )
                        .padding(.horizontal, sidePadding)
                    }

                    Spacer().frame(height: 26)
                    Spacer().frame(height: 120)
                }
            }
        }
        .background(bg.ignoresSafeArea())
    }
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
                Capsule(style: .continuous).fill(fillColor)
            )
            .overlay(
                Capsule(style: .continuous).stroke(strokeColor, lineWidth: 1)
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

    private func dotsRow(startIndex: Int, count: Int) -> some View {
        HStack(spacing: spacing) {
            ForEach(0..<count, id: \.self) { offset in
                dot(index: startIndex + offset)
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func dot(index: Int) -> some View {
        let isFilled = index < filledCount
        let isSelected = (selectedIndex == index)
        let stroke = isSelected ? selectedStrokeColor : strokeColor

        return ZStack {
            Circle().fill(isFilled ? fillColor.opacity(0.16) : Color.clear)
            Circle().stroke(stroke, lineWidth: strokeWidth)

            Text("\(index + 1)")
                .font(AppFont.inter(size: 16, weight: .regular))
                .foregroundStyle(isFilled ? numberColor : .clear)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(width: circleSize, height: circleSize)
        .shadow(color: isFilled ? fillColor.opacity(0.18) : .clear, radius: 6, x: 0, y: 2)
    }
}

struct StageProgressArtView: View {

    let stage: MPStage
    let filledCount: Int

    let chrysalisAssetName: String
    let butterflyAssetName: String

    let gold: Color
    let cream: Color

    init(
        stage: MPStage,
        filledCount: Int,
        chrysalisAssetName: String,
        butterflyAssetName: String,
        gold: Color,
        cream: Color
    ) {
        self.stage = stage
        self.filledCount = max(0, min(20, filledCount))
        self.chrysalisAssetName = chrysalisAssetName
        self.butterflyAssetName = butterflyAssetName
        self.gold = gold
        self.cream = cream
    }

    var body: some View {
        switch stage {
        case .caterpillar:
            EmptyView()

        case .chrysalis:
            ChrysalisArtWithGridView(
                assetName: chrysalisAssetName,
                filledCount: filledCount,
                gold: gold,
                cream: cream
            )

        case .butterfly:
            ButterflyArtWithPositionsView(
                assetName: butterflyAssetName,
                filledCount: filledCount,
                gold: gold,
                cream: cream
            )
        }
    }
}

struct ChrysalisArtWithGridView: View {

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

                DiamondGrid20View(
                    filledCount: filledCount,
                    diamondSize: w * 0.090,
                    strokeWidth: 1.4,
                    hSpacing: w * 0.018,
                    vSpacing: w * 0.018,
                    gold: gold,
                    cream: cream
                )
                .frame(width: w * 0.62, height: h * 0.56)
                .position(x: w * 0.53, y: h * 0.52)
            }
            .frame(width: w, height: h)
        }
        .aspectRatio(1.20, contentMode: .fit)
    }
}

struct ButterflyArtWithPositionsView: View {

    let assetName: String
    let filledCount: Int
    let gold: Color
    let cream: Color

    private let markerSize: CGFloat = 28
    private let strokeWidth: CGFloat = 1.5

    private let wingSpread: CGFloat = 0.08

    var body: some View {
        GeometryReader { geo in
            let size = geo.size

            ZStack {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.width, height: size.height)

                ForEach(0..<min(ButterflyPositions.normalized.count, 20), id: \.self) { i in
                    let p0 = ButterflyPositions.normalized[i]
                    let p = spread(p0, amount: wingSpread)

                    let x = p.x * size.width
                    let y = p.y * size.height
                    let isFilled = i < filledCount

                    ZStack {
                        Circle()
                            .fill(isFilled ? gold.opacity(0.65) : Color.clear)

                        Circle()
                            .stroke(gold.opacity(0.90), lineWidth: strokeWidth)

                        Text("\(i + 1)")
                            .font(AppFont.inter(size: 12, weight: .medium))
                            .foregroundStyle(cream.opacity(isFilled ? 0.95 : 0.45))
                            .minimumScaleFactor(0.7)
                            .lineLimit(1)
                    }
                    .frame(width: markerSize, height: markerSize)
                    .position(x: x, y: y)
                }
            }
            .frame(width: size.width, height: size.height)
        }
        .aspectRatio(1.15, contentMode: .fit)
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

struct DiamondShape: Shape {
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

struct DiamondGrid20View: View {

    let filledCount: Int

    let diamondSize: CGFloat
    let strokeWidth: CGFloat
    let hSpacing: CGFloat
    let vSpacing: CGFloat

    let gold: Color
    let cream: Color

    init(
        filledCount: Int,
        diamondSize: CGFloat,
        strokeWidth: CGFloat,
        hSpacing: CGFloat,
        vSpacing: CGFloat,
        gold: Color,
        cream: Color
    ) {
        self.filledCount = max(0, min(20, filledCount))
        self.diamondSize = diamondSize
        self.strokeWidth = strokeWidth
        self.hSpacing = hSpacing
        self.vSpacing = vSpacing
        self.gold = gold
        self.cream = cream
    }

    var body: some View {
        let cols: [GridItem] = Array(
            repeating: GridItem(.fixed(diamondSize), spacing: hSpacing, alignment: .center),
            count: 4
        )

        LazyVGrid(columns: cols, alignment: .center, spacing: vSpacing) {
            ForEach(0..<20, id: \.self) { idx in
                diamond(index: idx)
                    .frame(width: diamondSize, height: diamondSize)
            }
        }
    }

    private func diamond(index: Int) -> some View {
        let isFilled = index < filledCount

        return ZStack {
            DiamondShape()
                .fill(isFilled ? gold.opacity(0.60) : Color.clear)

            DiamondShape()
                .stroke(gold.opacity(0.95), lineWidth: strokeWidth)

            Text("\(index + 1)")
                .font(AppFont.inter(size: 12, weight: .medium))
                .foregroundStyle(cream.opacity(isFilled ? 0.95 : 0.45))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

private enum ButterflyPositions {
    static let normalized: [CGPoint] = [
        CGPoint(x: 0.22, y: 0.33), CGPoint(x: 0.32, y: 0.33),
        CGPoint(x: 0.22, y: 0.43), CGPoint(x: 0.32, y: 0.43),
        CGPoint(x: 0.22, y: 0.53), CGPoint(x: 0.32, y: 0.53),
        CGPoint(x: 0.22, y: 0.63), CGPoint(x: 0.32, y: 0.63),
        CGPoint(x: 0.22, y: 0.73), CGPoint(x: 0.32, y: 0.73),

        CGPoint(x: 0.68, y: 0.33), CGPoint(x: 0.78, y: 0.33),
        CGPoint(x: 0.68, y: 0.43), CGPoint(x: 0.78, y: 0.43),
        CGPoint(x: 0.68, y: 0.53), CGPoint(x: 0.78, y: 0.53),
        CGPoint(x: 0.68, y: 0.63), CGPoint(x: 0.78, y: 0.63),
        CGPoint(x: 0.68, y: 0.73), CGPoint(x: 0.78, y: 0.73)
    ]
}


#Preview {
    HomeRootView()
        .environmentObject(AppStore())
}

