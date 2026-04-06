import Foundation

enum DashboardHTML {
    static var html: String {
        guard let url = Bundle.main.url(forResource: "dashboard", withExtension: "html"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return "<html><body><h1>Dashboard not found</h1></body></html>"
        }
        return content
    }
}
