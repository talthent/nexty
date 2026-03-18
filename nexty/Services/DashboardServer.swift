import Foundation
import Network

final class DashboardServer: @unchecked Sendable {
    private var listener: NWListener?
    private weak var appState: AppState?
    let port: UInt16 = 8080

    func start(appState: AppState) {
        self.appState = appState
        guard let nwPort = NWEndpoint.Port(rawValue: port) else { return }
        do {
            listener = try NWListener(using: .tcp, on: nwPort)
        } catch { return }

        listener?.newConnectionHandler = { [weak self] connection in
            self?.handleConnection(connection)
        }
        listener?.start(queue: .main)
    }

    func stop() {
        listener?.cancel()
        listener = nil
    }

    private func handleConnection(_ connection: NWConnection) {
        connection.start(queue: .main)
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, _, _ in
            guard let self, let data else {
                connection.cancel()
                return
            }
            let (method, path, body) = self.parseRequest(data)
            let (status, contentType, responseBody) = self.route(method: method, path: path, body: body)
            self.sendResponse(connection, status: status, contentType: contentType, body: responseBody)
        }
    }

    private func parseRequest(_ data: Data) -> (method: String, path: String, body: Data?) {
        guard let str = String(data: data, encoding: .utf8) else {
            return ("GET", "/", nil)
        }
        let parts = str.components(separatedBy: "\r\n\r\n")
        let headerSection = parts.first ?? ""
        let body = parts.count > 1 ? parts.dropFirst().joined(separator: "\r\n\r\n").data(using: .utf8) : nil
        let firstLine = headerSection.components(separatedBy: "\r\n").first ?? ""
        let tokens = firstLine.components(separatedBy: " ")
        let method = tokens.count > 0 ? tokens[0] : "GET"
        let path = tokens.count > 1 ? tokens[1] : "/"
        return (method, path, body)
    }

    private func route(method: String, path: String, body: Data?) -> (status: String, contentType: String, body: Data) {
        switch (method, path) {
        case ("GET", "/"):
            return ("200 OK", "text/html; charset=utf-8", Data(DashboardHTML.html.utf8))

        case ("GET", "/activities"):
            let activities = appState?.activities ?? []
            let data = (try? JSONEncoder().encode(activities)) ?? Data("[]".utf8)
            return ("200 OK", "application/json", data)

        case ("PUT", "/activities"):
            if let body, let decoded = try? JSONDecoder().decode([Activity].self, from: body) {
                Task { @MainActor [weak self] in
                    self?.appState?.replaceActivities(decoded)
                }
                return ("200 OK", "application/json", Data("{\"ok\":true}".utf8))
            }
            return ("400 Bad Request", "application/json", Data("{\"error\":\"invalid json\"}".utf8))

        default:
            return ("404 Not Found", "text/plain", Data("Not Found".utf8))
        }
    }

    private func sendResponse(_ connection: NWConnection, status: String, contentType: String, body: Data) {
        let header = "HTTP/1.1 \(status)\r\nContent-Type: \(contentType)\r\nContent-Length: \(body.count)\r\nAccess-Control-Allow-Origin: *\r\nConnection: close\r\n\r\n"
        var responseData = Data(header.utf8)
        responseData.append(body)
        connection.send(content: responseData, completion: .contentProcessed { _ in
            connection.cancel()
        })
    }
}
