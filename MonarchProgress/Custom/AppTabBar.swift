//
//  AppTabBar.swift
//  MonarchProgress
//
//  Created by Алексей Авер on 16.02.2026.
//


import SwiftUI

struct AppTabBar: View {

    @Binding var selected: AppTab

    private let barHeight: CGFloat = 72

    private var hairline: CGFloat { 1 / UIScreen.main.scale }

    var body: some View {
        VStack(spacing: 0) {

            Rectangle()
                .fill(Color(hex:"D4AF37").opacity(0.5))
                .frame(height: hairline)

            HStack(spacing: 0) {
                ForEach(AppTab.allCases) { tab in
                    tabButton(tab)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: barHeight)
            .background(Color(hex:"1a0f0a"))
        }
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            selected = tab
        } label: {
            VStack(spacing: 6) {
                Image(tab.iconAssetName)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)

                Text(tab.title)
                    .font(AppFont.inter(size: 12, weight: .medium))
            }
            .foregroundStyle(tabForegroundColor(tab))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func tabForegroundColor(_ tab: AppTab) -> Color {
        if tab == selected {
            return Color(hex: "D4AF37")
        } else {
            return Color(hex: "F7E7CE").opacity(0.5)
        }
    }
}
