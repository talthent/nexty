import SwiftUI

struct ActivityCardView: View {
    let state: ActivityCardState

    var body: some View {
        Button { } label: {
            ZStack {
                VStack(spacing: 16) {
                    Text(state.timeString)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))

                    Spacer()

                    Text(state.title)
                        .font(.system(size: 36, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(.vertical, 54)

                Image("lucide-\(state.imageName)")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
                    .frame(width: 80, height: 80)
                    .frame(width: 140, height: 140)
            }
            .frame(width: 280, height: 340)
            .background(.ultraThinMaterial)
            .opacity(state.opacity)
            .overlay(alignment: .topLeading) {
                switch state.badge {
                case .now:
                    NowBadge()
                case .comingNext:
                    ComingNextBadge()
                case .none:
                    EmptyView()
                }
            }
        }
        .buttonStyle(.card)
    }
}

#Preview {
    HStack(spacing: 32) {
        ActivityCardView(state: ActivityCardState(
            activity: Activity(titleKey: "activity.breakfast", imageName: "utensils", hour: 7, minute: 30),
            index: 0, language: .english, use24Hour: true, isCurrent: false, isNext: false, isPast: true
        ))
        ActivityCardView(state: ActivityCardState(
            activity: Activity(titleKey: "activity.kindergarten", imageName: "backpack", hour: 8, minute: 30),
            index: 1, language: .english, use24Hour: true, isCurrent: true, isNext: false, isPast: false
        ))
        ActivityCardView(state: ActivityCardState(
            activity: Activity(titleKey: "activity.lunch", imageName: "carrot", hour: 12, minute: 30),
            index: 2, language: .english, use24Hour: true, isCurrent: false, isNext: true, isPast: false
        ))
    }
    .padding()
    .background {
        Image("Bluey")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

private struct NowBadge: View {
    @Environment(\.appLanguage) private var language

    var body: some View {
        Text("now".localized(language))
            .font(.system(size: 25, weight: .heavy, design: .rounded))
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(.white, in: .rect(bottomTrailingRadius: 14))
    }
}

private struct ComingNextBadge: View {
    @Environment(\.appLanguage) private var language

    var body: some View {
        Text("comingNext".localized(language))
            .font(.system(size: 25, weight: .heavy, design: .rounded))
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 6)
            .background(.yellow, in: .rect(bottomTrailingRadius: 14))
    }
}
