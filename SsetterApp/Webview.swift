import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()

        config.allowsInlineMediaPlayback = true // ✅ 비디오가 전체화면으로 전환되지 않도록 설정
        config.mediaTypesRequiringUserActionForPlayback = [] // 자동 재생 허용

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator

        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        let request = URLRequest(url: url)
        webView.load(request)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // myapp://login 딥링크 감지
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ WebView loaded:", webView.url?.absoluteString ?? "")
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

            if let url = navigationAction.request.url,
               url.scheme == "myapp" {

                print("📲 딥링크 감지됨: \(url.absoluteString)")

                if url.host == "login" {
                    print("🔑 로그인 요청 딥링크 감지됨 (WebView에서 직접 실행)")
                    
                    // ✅ 바로 로그인 실행
                    AuthService.onTokenReceived = { token in
                        print("✅ WebView로 토큰 전달 준비: \(token)")
                        // 예시: JS 전달도 가능 (webView.evaluateJavaScript)
                    }
                    AuthService().startGoogleLogin()
                }

                decisionHandler(.cancel)
                return
            }

            decisionHandler(.allow)
        }
    }
}
