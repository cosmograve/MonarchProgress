//
//  AppTextField.swift
//  MonarchProgress
//
//  Created by Алексей Авер on 16.02.2026.
//


import SwiftUI

struct AppTextField: View {

    let placeholder: String
    @Binding var text: String

    private let gold = AppColors.gold
    private let cream = AppColors.cream

    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFont.inter(size: 14, weight: .regular))
            .foregroundStyle(cream)
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
}