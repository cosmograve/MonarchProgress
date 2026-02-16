//
//  CompletionDatePickerScreen.swift
//  MonarchProgress
//
//  Created by Алексей Авер on 16.02.2026.
//


import SwiftUI

struct CompletionDatePickerScreen: View {

    @Binding var selectedDate: Date
    @Binding var isPresented: Bool

    private let bg = AppColors.background
    private let cream = AppColors.cream
    private let gold = AppColors.gold

    var body: some View {
        VStack(spacing: 0) {

            HStack {
                Text("Completion Date")
                    .font(AppFont.inter(size: 18, weight: .medium))
                    .foregroundStyle(cream)

                Spacer()

                Button {
                    isPresented = false
                } label: {
                    Text("Done")
                        .font(AppFont.inter(size: 16, weight: .medium))
                        .foregroundStyle(Color(hex: "1A0F0A"))
                        .padding(.horizontal, 14)
                        .frame(height: 36)
                        .background(Capsule().fill(gold))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Divider()
                .overlay(gold.opacity(0.2))

            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date]
            )
            .datePickerStyle(.graphical)
            .labelsHidden()
            .tint(gold)
            .padding(16)

            Spacer()
        }
        .background(bg.ignoresSafeArea())
    }
}