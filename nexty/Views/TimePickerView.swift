import SwiftUI

struct TimePickerView: View {
    @Binding var hour: Int
    @Binding var minute: Int

    var body: some View {
        HStack(spacing: 16) {
            Button {
                adjustTime(by: -30)
            } label: {
                Image("lucide-chevron-left")
                    .resizable().scaledToFit()
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 28, height: 28)
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
                Image("lucide-chevron-right")
                    .resizable().scaledToFit()
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 28, height: 28)
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
