import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("MainView")
                    .font(AppFont.inter(size: 40, weight: .regular))
                Text("Онбординг больше не показывается ✅")
                    .opacity(0.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Monarch Progress")
        }
    }
}

#Preview {
    MainView()
}
