//
//  AppTextEditor.swift
//  MonarchProgress
//
//  Created by Алексей Авер on 16.02.2026.
//


import SwiftUI

struct AppTextEditor: View {

    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        ZStack(alignment: .topLeading) {

            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(placeholder)
                    .font(AppFont.inter(size: 14, weight: .regular))
                    .foregroundStyle(cream.opacity(0.35))
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
            }

            TextEditor(text: $text)
                .font(AppFont.inter(size: 14, weight: .regular))
                .foregroundStyle(cream)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
        }
        .frame(minHeight: minHeight)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white.opacity(0.03))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(gold.opacity(0.22), lineWidth: 1)
        )
    }
}