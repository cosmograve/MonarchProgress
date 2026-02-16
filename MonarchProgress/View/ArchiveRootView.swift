import SwiftUI

struct ArchiveRootView: View {

    @EnvironmentObject private var store: AppStore

    var body: some View {
        VStack(spacing: 0) {
            AppNavBar(onBackTap: nil)

            Spacer()

            Text("Archived cycles: \(store.archivedCycles.count)")
                .foregroundStyle(AppColors.cream.opacity(0.8))
                .font(AppFont.inter(size: 18, weight: .regular))

            Spacer()
        }
        .background(AppColors.background)
    }
}
