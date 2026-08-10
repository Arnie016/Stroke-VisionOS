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
    private var requestGeneration = 0
    private var pauseRequested = false
    private(set) var state: State = .off

    var isConfigured: Bool { realtimeProxyEndpoint != nil }

    /// The authored cerebral-flow bed remains audible at a lower level while
    /// narration is loading or speaking. Paused and failed narration do not
    /// keep the ambience ducked indefinitely.
    var shouldDuckAmbientAudio: Bool {
        !pauseRequested && (state == .loading || state == .speaking)
    }

    /// True while narration is fetching or still owns a player, including a
    /// player held by Pause. This prevents automatic copy progression from
    /// replacing a request that has not yet completed.
    var isBusy: Bool {
        requestTask != nil || player != nil
    }

    /// A new, explicit family opt-in starts audible even if the surrounding
    /// region lesson is already holding its visual flow. Pause changes after
    /// the request starts still latch through loading via `setPaused`.
    func beginOptInExactCaption(_ text: String) {
        pauseRequested = false
        speakExactCaption(text)
    }

    func speakExactCaption(_ text: String) {
        stop()
        guard !text.isEmpty else { return }
        guard let endpoint = realtimeProxyEndpoint else {
            state = .setupRequired
            return
        }

        requestGeneration += 1
        let generation = requestGeneration
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
                      http.value(forHTTPHeaderField: "X-RBC-Narration-Copy-SHA256") == Self.sha256(text),
                      http.value(forHTTPHeaderField: "X-RBC-Narration-Transcript-SHA256") == Self.canonicalSHA256(text)
                else {
                    guard let self, self.requestGeneration == generation else { return }
                    self.requestTask = nil
                    self.state = .unavailable
                    return
                }
                guard !Task.isCancelled,
                      let self,
                      self.requestGeneration == generation
                else { return }

                let player = try AVAudioPlayer(data: audio)
                self.requestTask = nil
                self.player = player
                player.delegate = self
                player.prepareToPlay()
                if self.pauseRequested {
                    self.state = .paused
                } else if player.play() {
                    self.state = .speaking
                } else {
                    self.player = nil
                    self.state = .unavailable
                }
            } catch {
                guard !Task.isCancelled,
                      let self,
                      self.requestGeneration == generation
                else { return }
                self.requestTask = nil
                self.state = .unavailable
            }
        }
    }

    func stop() {
        requestGeneration += 1
        requestTask?.cancel()
        requestTask = nil
        player?.stop()
        player = nil
        state = .off
    }

    func setPaused(_ paused: Bool) {
        pauseRequested = paused
        if paused {
            player?.pause()
            if requestTask != nil || player != nil {
                state = .paused
            }
            return
        }

        if let player {
            if player.play() {
                state = .speaking
            } else {
                self.player = nil
                state = .unavailable
            }
        } else if requestTask != nil {
            state = .loading
        }
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor [weak self] in
            guard self?.player === player else { return }
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

    /// Matches the proxy's punctuation-insensitive word-sequence gate. The
    /// exact source hash above protects the authored copy; this second hash
    /// protects what the provider reports it actually spoke.
    private static func canonicalSHA256(_ text: String) -> String {
        let locale = Locale(identifier: "en_US_POSIX")
        let folded = text
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: locale)
            .lowercased(with: locale)
        var separated = ""
        for scalar in folded.unicodeScalars {
            if CharacterSet.alphanumerics.contains(scalar) {
                separated.unicodeScalars.append(scalar)
            } else {
                separated.append(" ")
            }
        }
        let canonical = separated.split(whereSeparator: \Character.isWhitespace).joined(separator: " ")
        return sha256(canonical)
    }
}

private struct RBCRealtimeNarrationRequest: Encodable {
    let model: String
    let text: String
}
