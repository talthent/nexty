import SwiftUI

struct LoadingView: View {
    let headerState: HeaderViewState

    var body: some View {
        VStack {
            HeaderView(state: headerState)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 80)
                .padding(.top, 40)

            Spacer()
            ProgressView()
                .tint(.white)
            Spacer()
        }
    }
}
