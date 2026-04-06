import SwiftUI

struct TimePickerView: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Environment(\.appLanguage) private var language

    private var backChevron: String { language.isRTL ? "chevron.right" : "chevron.left" }
    private var forwardChevron: String { language.isRTL ? "chevron.left" : "chevron.right" }

    var body: some View {
        HStack(spacing: 16) {
            Button {
                adjustTime(by: -30)
            } label: {
                Image(systemName: backChevron)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(14)
            }
            .buttonStyle(.card)

            Text(String(format: "%d:%02d", hour, minute))
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .monospacedDigit()
                .frame(minWidth: 200)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.2), value: hour * 60 + minute)

            Button {
                adjustTime(by: 30)
            } label: {
                Image(systemName: forwardChevron)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(14)
            }
            .buttonStyle(.card)
        }
    }

    private func adjustTime(by minutes: Int) {
        var total = hour * 60 + minute + minutes
        if total < 0 { total += 24 * 60 }
        total = total % (24 * 60)
        hour = total / 60
        minute = total % 60
    }
}
