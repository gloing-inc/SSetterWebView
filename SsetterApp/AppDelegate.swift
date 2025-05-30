//
//  AppDelegate.swift
//  SsetterApp
//
//  Created by anonymous on 5/29/R7.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("📲 딥링크 수신됨:", url.absoluteString)
        AuthService().startGoogleLogin()
        
        if url.scheme == "myapp" {
            if url.host == "login" {
                // ex) myapp://login → Safari나 ASWebAuthenticationSession 열기
                print("🔑 로그인 요청 딥링크 감지됨")
            } else if url.host == "auth-success" {
                // ex) myapp://auth-success?token=xxxxx
                if let token = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                    .queryItems?.first(where: { $0.name == "token" })?.value {
                    print("✅ 로그인 성공, 토큰:", token)
                    // 토큰 저장 및 WebView에 전달 등 처리
                }
            }
        }
        return true
    }
}
