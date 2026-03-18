import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let url: String
    @State private var qrImage: UIImage?

    var body: some View {
        Group {
            if let qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(.rect(cornerRadius: 12))
            } else {
                ProgressView()
                    .frame(width: 200, height: 200)
            }
        }
        .task(id: url) {
            qrImage = await generateQR(from: url)
        }
    }

    private func generateQR(from string: String) async -> UIImage? {
        await Task.detached {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(string.utf8)
            filter.correctionLevel = "M"
            guard let output = filter.outputImage else { return nil }
            let scale = 200.0 / output.extent.width
            let scaled = output.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
            guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
            return UIImage(cgImage: cgImage)
        }.value
    }
}

#Preview {
    QRCodeView(url: "https://www.google.com")
}
