import AVFoundation
import CryptoKit
import Foundation
import Observation

@MainActor
@Observable
final class RBCFamilyNarrationEngine: NSObject, AVAudioPlayerDelegate {
    static let model = "gpt-realtime-2.1"

    enum State: Equatable {
        case off
        case setupRequired
        case loading
        case speaking
        case paused
        case ready
        case unavailable
    }

    private var player: AVAudioPlayer?
    private var requestTask: Task<Void, Never>?
    private(set) var state: State = .off

    var isConfigured: Bool { realtimeProxyEndpoint != nil }

    func speakExactCaption(_ text: String) {
        stop()
        guard !text.isEmpty else { return }
        guard let endpoint = realtimeProxyEndpoint else {
            state = .setupRequired
            return
        }

        state = .loading
        requestTask = Task { [weak self] in
            do {
                var request = URLRequest(url: endpoint)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.timeoutInterval = 25
                request.httpBody = try JSONEncoder().encode(
                    RBCRealtimeNarrationRequest(model: Self.model, text: text)
                )

                let (audio, response) = try await URLSession.shared.data(for: request)
                guard let http = response as? HTTPURLResponse,
                      (200..<300).contains(http.statusCode),
                      http.value(forHTTPHeaderField: "X-RBC-Narration-Model") == Self.model,
                      http.value(forHTTPHeaderField: "X-RBC-Narration-Copy-SHA256") == Self.sha256(text)
                else {
                    self?.state = .unavailable
                    return
                }
                guard !Task.isCancelled else { return }

                let player = try AVAudioPlayer(data: audio)
                self?.player = player
                player.delegate = self
                player.prepareToPlay()
                player.play()
                self?.state = .speaking
            } catch {
                guard !Task.isCancelled else { return }
                self?.state = .unavailable
            }
        }
    }

    func stop() {
        requestTask?.cancel()
        requestTask = nil
        player?.stop()
        player = nil
        state = .off
    }

    func setPaused(_ paused: Bool) {
        guard let player else { return }
        if paused {
            player.pause()
            state = .paused
        } else {
            player.play()
            state = .speaking
        }
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor [weak self] in
            self?.player = nil
            self?.state = flag ? .ready : .unavailable
        }
    }

    private var realtimeProxyEndpoint: URL? {
        let environment = ProcessInfo.processInfo.environment["RBC_REALTIME_PROXY_URL"]
        let bundled = Bundle.main.object(forInfoDictionaryKey: "RBCRealtimeProxyURL") as? String
        return (environment ?? bundled).flatMap(URL.init(string:))
    }

    private static func sha256(_ text: String) -> String {
        SHA256.hash(data: Data(text.utf8)).map { String(format: "%02x", $0) }.joined()
    }
}

private struct RBCRealtimeNarrationRequest: Encodable {
    let model: String
    let text: String
}
