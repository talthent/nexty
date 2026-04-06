import Foundation

enum DashboardHTML {
    static func load(_ name: String, ext: String) -> String? {
        guard let url = Bundle.main.url(forResource: name, withExtension: ext),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            return nil
        }
        return content
    }

    static var html: String {
        load("dashboard", ext: "html") ?? "<html><body><h1>Dashboard not found</h1></body></html>"
    }

    static var css: String {
        load("dashboard", ext: "css") ?? ""
    }

    static var js: String {
        load("dashboard", ext: "js") ?? ""
    }
}
