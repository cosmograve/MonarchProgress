import SwiftUI

enum AchievementEditorMode {
    case create
    case edit(achievement: MPAchievement)

    var title: String {
        switch self {
        case .create: return "New Achievement"
        case .edit: return "Edit Achievement"
        }
    }
}

struct AchievementEditorOverlay: View {


    @EnvironmentObject private var store: AppStore

    @Binding var isPresented: Bool

    let mode: AchievementEditorMode

    // MARK: - Form State

    @State private var titleText: String = ""

    @State private var descriptionText: String = ""

    @State private var targetDate: Date? = nil

    @State private var status: MPAchievementStatus = .inProgress

    @State private var showDatePicker: Bool = false

    // MARK: - Styling

    private let gold = AppColors.gold
    private let cream = AppColors.cream
    private let bg = AppColors.background

    private let cardCorner: CGFloat = 18

    private let sidePadding: CGFloat = 18

    // MARK: - Prefill

    private func prefillIfNeeded() {
        switch mode {
        case .create:
            break

        case .edit(let a):
            titleText = a.title
            descriptionText = a.details
            targetDate = a.targetDate
            status = a.status
        }
    }

    // MARK: - Body

    var body: some View {
        ZStack {

            Color.black.opacity(0.82)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(spacing: 0) {

                header()

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 14) {

                        fieldTitle("Title")
                        AppTextField(
                            placeholder: "e.g., Promotion",
                            text: $titleText
                        )

                        fieldTitle("Description")
                        AppTextEditor(
                            placeholder: "e.g., I want to become a senior manager...",
                            text: $descriptionText,
                            minHeight: 88
                        )

                        fieldTitle("Completion Date")
                        DateFieldButton(
                            title: targetDateText(),
                            isPlaceholder: targetDate == nil
                        ) {
                            hideKeyboard()
                            showDatePicker = true
                        }

                        fieldTitle("Status")
                        statusButtons()

                        buttonsRow()
                    }
                    .padding(sidePadding)
                }
            }
            .frame(maxWidth: 360)
            .background(cardBackground())
            .padding(.horizontal, 24)
        }
        .dismissKeyboardOnTap()
        .keyboardDoneToolbar(title: "Done")
        .onAppear { prefillIfNeeded() }
        .fullScreenCover(isPresented: $showDatePicker) {
            CompletionDatePickerScreen(
                selectedDate: Binding(
                    get: { targetDate ?? Date() },
                    set: { targetDate = $0 }
                ),
                isPresented: $showDatePicker
            )
            .background(bg.ignoresSafeArea())
        }
    }

    // MARK: - Card Background

    private func cardBackground() -> some View {
        RoundedRectangle(cornerRadius: cardCorner, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color(hex: "2A1A12"),
                        Color(hex: "1E120D")
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: cardCorner, style: .continuous)
                    .stroke(gold.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.35), radius: 22, x: 0, y: 18)
    }

    // MARK: - Header

    private func header() -> some View {
        HStack(spacing: 12) {

            Text(mode.title)
                .font(AppFont.inter(size: 18, weight: .medium))
                .foregroundStyle(cream)

            Spacer()

            Button {
                // Закрываем оверлей
                isPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(cream.opacity(0.7))
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(sidePadding)
        .padding(.top, 4)
    }

    // MARK: - Field Titles

    private func fieldTitle(_ text: String) -> some View {
        Text(text)
            .font(AppFont.inter(size: 14, weight: .medium))
            .foregroundStyle(cream.opacity(0.85))
    }

    // MARK: - Date text

    private func targetDateText() -> String {
        guard let targetDate else { return "Select date" }
        return DateFormatter.shortMonDayYear.string(from: targetDate)
    }

    // MARK: - Status Buttons

    private func statusButtons() -> some View {
        HStack(spacing: 12) {
            statusButton(title: "In Progress", value: .inProgress)
            statusButton(title: "Completed", value: .done)
        }
    }

    private func statusButton(title: String, value: MPAchievementStatus) -> some View {
        let isSelected = (status == value)

        return Button {
            status = value
        } label: {
            Text(title)
                .font(AppFont.inter(size: 14, weight: .medium))
                .foregroundStyle(isSelected ? Color(hex: "1A0F0A") : cream.opacity(0.8))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? gold : Color.white.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(gold.opacity(isSelected ? 0.0 : 0.22), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom Buttons

    private func buttonsRow() -> some View {
        HStack(spacing: 12) {

            Button {
                isPresented = false
            } label: {
                Text("Cancel")
                    .font(AppFont.inter(size: 16, weight: .medium))
                    .foregroundStyle(cream.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.02))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(gold.opacity(0.22), lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)

            Button {
                onSave()
            } label: {
                Text("Save")
                    .font(AppFont.inter(size: 16, weight: .medium))
                    .foregroundStyle(Color(hex: "1A0F0A"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(gold)
                    )
                    .shadow(color: gold.opacity(0.25), radius: 16, x: 0, y: 10)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
    }

    // MARK: - Save

    private func onSave() {
        hideKeyboard()

        let trimmedTitle = titleText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            return
        }

        switch mode {
        case .create:
            store.addAchievement(
                title: trimmedTitle,
                details: descriptionText,
                targetDate: targetDate,
                status: status
            )

        case .edit(let a):
            store.updateAchievement(
                id: a.id,
                title: trimmedTitle,
                details: descriptionText,
                targetDate: targetDate,
                status: status
            )
        }

        isPresented = false
    }
}
