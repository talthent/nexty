import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    let language: Language
    let use24Hour: Bool
    let isCurrent: Bool
    let isNext: Bool
    let isPast: Bool

    var body: some View {
        Button { } label: {
            VStack(spacing: 16) {
                Text(activity.timeString(use24Hour: use24Hour))
                    .font(.system(size: 26, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))

                Image(systemName: activity.imageName)
                    .font(.system(size: 80, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 140, height: 140)

                Text(activity.title(for: language))
                    .font(.system(size: 36, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(width: 280, height: 340)
            .background(.thinMaterial)
            .opacity(isPast ? 0.6 : 1.0)
            .overlay(alignment: .topLeading) {
                if isCurrent {
                    NowBadge(language: language)
                } else if isNext {
                    ComingNextBadge(language: language)
                }
            }
        }
        .buttonStyle(.card)
    }
}

#Preview {
    HStack(spacing: 32) {
        ActivityCardView(
            activity: Activity(titleKey: "activity.breakfast", imageName: "fork.knife", hour: 7, minute: 30),
            language: .english,
            use24Hour: true,
            isCurrent: false,
            isNext: false,
            isPast: true
        )
        ActivityCardView(
            activity: Activity(titleKey: "activity.school", imageName: "backpack.fill", hour: 8, minute: 30),
            language: .english,
            use24Hour: true,
            isCurrent: true,
            isNext: false,
            isPast: false
        )
        ActivityCardView(
            activity: Activity(titleKey: "activity.lunch", imageName: "carrot.fill", hour: 12, minute: 30),
            language: .english,
            use24Hour: true,
            isCurrent: false,
            isNext: true,
            isPast: false
        )
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
    let language: Language

    var body: some View {
        Text(String(localized: String.LocalizationValue("now"), bundle: language.bundle))
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 4)
            .background(.white, in: .rect(bottomTrailingRadius: 12))
    }
}

private struct ComingNextBadge: View {
    let language: Language

    var body: some View {
        Text(String(localized: String.LocalizationValue("comingNext"), bundle: language.bundle))
            .font(.system(size: 18, weight: .heavy, design: .rounded))
            .foregroundStyle(.black)
            .padding(.horizontal, 14)
            .padding(.vertical, 4)
            .background(.yellow, in: .rect(bottomTrailingRadius: 12))
    }
}
