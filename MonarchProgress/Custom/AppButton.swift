
import SwiftUI

struct AppButtonShadow: Equatable {

    /// Включена ли тень.
    var isEnabled: Bool

    /// Радиус размытия тени.
    var radius: CGFloat

    /// Смещение тени по оси X.
    var x: CGFloat

    /// Смещение тени по оси Y.
    var y: CGFloat

    /// Прозрачность тени (0...1).
    var opacity: Double

    /// Создаёт "выключенную" тень.
    static var none: AppButtonShadow {
        AppButtonShadow(isEnabled: false, radius: 0, x: 0, y: 0, opacity: 0)
    }

    /// Нормальная мягкая тень по умолчанию.
    static var soft: AppButtonShadow {
        AppButtonShadow(isEnabled: true, radius: 12, x: 0, y: 6, opacity: 0.22)
    }
}

// MARK: - Size config

/// Настройки размера кнопки.
/// Можно:
/// - fixed: задать точные ширину/высоту
/// - fullWidth: занять всю доступную ширину, указав высоту
enum AppButtonSize: Equatable {
    case fixed(width: CGFloat, height: CGFloat)
    case fullWidth(height: CGFloat)

    /// Высота кнопки (общая для обоих кейсов).
    var height: CGFloat {
        switch self {
        case let .fixed(_, height): return height
        case let .fullWidth(height): return height
        }
    }
}

struct AppButton: View {

    // MARK: - Inputs

    let title: String

    let size: AppButtonSize

    let cornerRadius: CGFloat

    let backgroundColor: Color

    let foregroundColor: Color

    let shadow: AppButtonShadow

    let isEnabled: Bool

    let action: () -> Void

    init(
        title: String,
        size: AppButtonSize = .fullWidth(height: 52),
        cornerRadius: CGFloat = 12,
        backgroundColor: Color = Color(hex: "D4AF37"),
        foregroundColor: Color = Color(hex: "1A0F0A"),
        shadow: AppButtonShadow = .soft,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.shadow = shadow
        self.isEnabled = isEnabled
        self.action = action
    }


    var body: some View {
        Button {
            guard isEnabled else { return }
            action()
        } label: {
            Text(title)
                .font(AppFont.inter(size: 20, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(maxWidth: maxWidth, minHeight: size.height, maxHeight: size.height)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(backgroundColor.opacity(isEnabled ? 1.0 : 0.45))
        )
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(Color.white.opacity(isEnabled ? 0.10 : 0.06), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .applyShadowIfNeeded(shadow: shadow, isEnabled: isEnabled)
        .animation(.easeInOut(duration: 0.18), value: isEnabled)
        .accessibilityLabel(Text(title))
    }


    private var maxWidth: CGFloat? {
        switch size {
        case .fullWidth:
            return .infinity
        case let .fixed(width, _):
            return width
        }
    }
}


private extension View {

    @ViewBuilder
    func applyShadowIfNeeded(shadow: AppButtonShadow, isEnabled: Bool) -> some View {
        if shadow.isEnabled && isEnabled {
            self.shadow(
                color: Color(hex: "D4AF37"),
                radius: shadow.radius,
                x: shadow.x,
                y: shadow.y
            )
        } else {
            self
        }
    }
}
