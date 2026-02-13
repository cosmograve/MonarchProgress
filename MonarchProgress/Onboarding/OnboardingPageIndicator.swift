import SwiftUI

struct OnboardingPageIndicatorMG: View {

    let total: Int
    @Binding var currentIndex: Int

    let activeColor: Color
    let inactiveColor: Color

    let dotSize: CGFloat
    let activeWidth: CGFloat
    let height: CGFloat
    let spacing: CGFloat

    let cellWidth: CGFloat

    @Namespace private var mgNamespace

    init(
        total: Int,
        currentIndex: Binding<Int>,
        activeColor: Color = Color(hex: "D4AF37"),
        inactiveColor: Color = Color(hex: "D4AF37").opacity(0.2),
        dotSize: CGFloat = 9,
        activeWidth: CGFloat = 46,
        height: CGFloat = 10,
        spacing: CGFloat = 6,
        cellWidth: CGFloat = 14
    ) {
        self.total = total
        self._currentIndex = currentIndex
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
        self.activeWidth = activeWidth
        self.height = height
        self.spacing = spacing
        self.cellWidth = cellWidth
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<max(total, 0), id: \.self) { index in
                ZStack {
                    Circle()
                        .fill(inactiveColor)
                        .frame(width: dotSize, height: dotSize)

                    if index == currentIndex {
                        Capsule(style: .continuous)
                            .fill(activeColor)
                            .frame(width: activeWidth, height: height)
                            .matchedGeometryEffect(id: "activePill", in: mgNamespace)
                    }
                }
                .frame(width: cellWidth, height: max(height, dotSize))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: currentIndex)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Page \(currentIndex + 1) of \(total)")
    }
}
