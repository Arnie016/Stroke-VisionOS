import SwiftUI
import WebKit

/// A low-motion environmental horizon borrowed from the Paper Shader
/// experiment in Ashfall Vision. It is deliberately separated from the
/// anatomical model: this layer conveys calm and continuity, not blood,
/// perfusion, pressure, emotion, or any patient measurement.
struct CalmPaperFlowView: UIViewRepresentable {
    var isPaused = false

    func makeCoordinator() -> Coordinator {
        Coordinator(owner: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        configuration.setURLSchemeHandler(CalmPaperFlowSchemeHandler(), forURLScheme: "strokeflow")

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        webView.isUserInteractionEnabled = false
        context.coordinator.webView = webView
        webView.load(URLRequest(url: URL(string: "strokeflow://bundle/index.html")!))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        context.coordinator.owner = self
        context.coordinator.applySettings()
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var owner: CalmPaperFlowView
        weak var webView: WKWebView?
        private var pageIsReady = false

        init(owner: CalmPaperFlowView) {
            self.owner = owner
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            pageIsReady = true
            applySettings()
        }

        func applySettings() {
            guard pageIsReady, let webView else { return }
            let payload: [String: Any] = [
                "colors": ["#0B1E23", "#245C61", "#69B8AD", "#E8B9A5", "#FFF2DF"],
                "speed": owner.isPaused ? 0.0 : 0.14,
                "distortion": 0.30,
                "swirl": 0.34,
                "grain": 0.055,
                "scale": 1.08,
                "rotation": -4.0,
                "originX": 0.48,
                "originY": 0.52,
                "wandMode": false,
                "soundMode": false,
                "depthMode": false,
                "displayText": "",
                "displayFont": "rounded"
            ]
            guard
                JSONSerialization.isValidJSONObject(payload),
                let data = try? JSONSerialization.data(withJSONObject: payload),
                let json = String(data: data, encoding: .utf8)
            else { return }

            webView.evaluateJavaScript("window.paperShaderUpdate && window.paperShaderUpdate(\(json));")
        }
    }
}

private final class CalmPaperFlowSchemeHandler: NSObject, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        guard
            let requestURL = urlSchemeTask.request.url,
            let resourceRoot = Bundle.main.resourceURL?.appendingPathComponent("PaperShader", isDirectory: true)
        else {
            fail(urlSchemeTask)
            return
        }

        let relativePath = requestURL.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let safePath = relativePath.isEmpty ? "index.html" : relativePath
        let fileURL = resourceRoot.appendingPathComponent(safePath)

        guard
            fileURL.standardizedFileURL.path.hasPrefix(resourceRoot.standardizedFileURL.path),
            let data = try? Data(contentsOf: fileURL)
        else {
            fail(urlSchemeTask)
            return
        }

        let response = URLResponse(
            url: requestURL,
            mimeType: mimeType(for: fileURL.pathExtension),
            expectedContentLength: data.count,
            textEncodingName: "utf-8"
        )
        urlSchemeTask.didReceive(response)
        urlSchemeTask.didReceive(data)
        urlSchemeTask.didFinish()
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {}

    private func fail(_ urlSchemeTask: WKURLSchemeTask) {
        urlSchemeTask.didFailWithError(URLError(.fileDoesNotExist))
    }

    private func mimeType(for pathExtension: String) -> String {
        switch pathExtension.lowercased() {
        case "html": "text/html"
        case "css": "text/css"
        case "js": "application/javascript"
        case "json", "map": "application/json"
        default: "application/octet-stream"
        }
    }
}
