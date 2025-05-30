import Foundation
import AuthenticationServices
import UIKit

class AuthService: NSObject {
    private var session: ASWebAuthenticationSession?

    // 토큰 전달을 위한 핸들러 (예: AppDelegate에서 지정)
    static var onTokenReceived: ((String) -> Void)?

    func startGoogleLogin() {
        let clientId = "981067743731-gs6i40krtbtmvhhsmimmfqtnlt8g423t.apps.googleusercontent.com"
        let redirectUri = "https://ssetter.com"
        let scope = "openid%20email%20profile"
        let state = UUID().uuidString

        // Implicit Flow (token 바로 받기)
        guard let authURL = URL(string:
            "https://accounts.google.com/o/oauth2/v2/auth" +
            "?response_type=token" +
            "&client_id=\(clientId)" +
            "&redirect_uri=\(redirectUri)" +
            "&scope=\(scope)" +
            "&state=\(state)"
        ) else {
            print("❌ 잘못된 URL")
            return
        }

        session = ASWebAuthenticationSession(
            url: authURL,
            callbackURLScheme: "myapp"
        ) { callbackURL, error in
            if let error = error {
                print("❌ 로그인 실패:", error.localizedDescription)
                return
            }

            guard let callbackURL = callbackURL,
                  let fragment = URLComponents(url: callbackURL, resolvingAgainstBaseURL: false)?.fragment else {
                print("❌ 콜백 URL 오류")
                return
            }

            let params = self.parseFragment(fragment)
            if let accessToken = params["access_token"] {
                print("✅ 로그인 성공, access_token:", accessToken)

                // 전달할 곳으로 access_token 넘기기
                AuthService.onTokenReceived?(accessToken)
            } else {
                print("❌ access_token 없음")
            }
        }

        session?.presentationContextProvider = self
        session?.prefersEphemeralWebBrowserSession = true
        session?.start()
    }

    // URL fragment 파싱: access_token=xxx&expires_in=3600 ...
    private func parseFragment(_ fragment: String) -> [String: String] {
        return fragment
            .components(separatedBy: "&")
            .reduce(into: [String: String]()) { result, pair in
                let parts = pair.components(separatedBy: "=")
                if parts.count == 2 {
                    result[parts[0]] = parts[1]
                }
            }
    }
}

// ASWebAuthenticationSession을 위한 프레젠테이션 컨텍스트
extension AuthService: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // iOS 15 이상 대응
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            return window
        }

        // fallback (iOS 13, 14 등)
        return UIApplication.shared.windows.first ?? UIWindow()
    }
}
