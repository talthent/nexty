import SwiftUI
import AVKit

struct AvatarPreview: View {
    let avatar: Avatar
    let size: CGFloat

    var body: some View {
        ZStack {
            Image(avatar.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)

            if let videoName = avatar.animatedVideoName,
               let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") {
                LoopingVideoView(url: url)
                    .frame(width: size, height: size)
            }
        }
        .clipShape(Circle())
        .id(avatar)
    }
}

class PlayerUIView: UIView {
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    private var playerLayer: AVPlayerLayer?

    func configure(url: URL) {
        playerLayer?.removeFromSuperlayer()
        player?.pause()

        let player = AVQueuePlayer()
        let item = AVPlayerItem(url: url)
        let looper = AVPlayerLooper(player: player, templateItem: item)
        self.player = player
        self.looper = looper

        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        self.layer.addSublayer(layer)
        self.playerLayer = layer

        player.isMuted = true
        player.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

struct LoopingVideoView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.backgroundColor = .clear
        view.configure(url: url)
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {}
}
