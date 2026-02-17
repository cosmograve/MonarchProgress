import SwiftUI

struct DateFieldButton: View {

    let title: String
    let isPlaceholder: Bool
    let onTap: () -> Void

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .font(AppFont.inter(size: 14, weight: .regular))
                    .foregroundStyle(isPlaceholder ? cream.opacity(0.35) : cream)

                Spacer()
            }
            .padding(.horizontal, 14)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.03))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(gold.opacity(0.22), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
