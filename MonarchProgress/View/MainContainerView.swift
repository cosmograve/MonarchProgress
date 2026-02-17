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
            .safeAreaInset(edge: .bottom) {
                AppTabBar(selected: $selectedTab)
            }

            if store.isAchievementEditorPresented {
                AchievementEditorOverlay(
                    isPresented: Binding(
                        get: { store.isAchievementEditorPresented },
                        set: { newValue in
                            store.isAchievementEditorPresented = newValue
                        }
                    ),
                    mode: store.achievementEditorMode
                )
                .padding(.top)
                .environmentObject(store)
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .environmentObject(store)
        .onAppear { store.load() }
        .animation(.easeInOut(duration: 0.18), value: store.isAchievementEditorPresented)
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
