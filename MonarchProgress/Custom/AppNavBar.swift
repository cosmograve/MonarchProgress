import SwiftUI

struct AppNavBar: View {

    let onBackTap: (() -> Void)?

    var foreground: Color = Color(hex: "F7E7CE")
    var background: Color = Color(hex: "1A0F0A")

    var logoAssetName: String = "nav_title"
    var backChevronAssetName: String = "nav_back_chevron"

    private let height: CGFloat = 64
    private var hairline: CGFloat { 1 / UIScreen.main.scale }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                background

                centerTitle()
                    .padding(.horizontal, 76)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    leftBack()
                    Spacer()
                }
                .padding(.leading, 16)
            }
            .frame(height: height)

            Rectangle()
                .fill(Color(hex: "D4AF37").opacity(0.2))
                .frame(height: hairline)
        }
    }


    private func centerTitle() -> some View {
        HStack(spacing: 8) {
            Image(logoAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)

            Text("Monarch Progress")
                .font(AppFont.inter(size: 32, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .allowsTightening(true)
        }
        .foregroundStyle(foreground)
    }


    @ViewBuilder
    private func leftBack() -> some View {
        if let onBackTap {
            Button(action: onBackTap) {
                HStack(spacing: 8) {
                    Image(backChevronAssetName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)

                    Text("Back")
                        .font(AppFont.inter(size: 16, weight: .medium))
                }
                .foregroundStyle(foreground)
                .frame(height: 44)
            }
            .buttonStyle(.plain)
        } else {
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
}
