import SwiftUI

struct MainContainerView: View {

    @State private var selectedTab: AppTab = .home

    @StateObject private var store = AppStore()

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                tabContent()
            }
        }
        .environmentObject(store)
        .onAppear {
            store.load()
        }
        .safeAreaInset(edge: .bottom) {
            AppTabBar(selected: $selectedTab)
        }
    }

    @ViewBuilder
    private func tabContent() -> some View {
        switch selectedTab {
        case .home:
            HomeRootView()
        case .achievements:
            AchievementsRootView()
        case .archive:
            ArchiveRootView()
        }
    }
}

#Preview {
    MainContainerView()
}
