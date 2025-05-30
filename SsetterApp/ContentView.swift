//
//  ContentView.swift
//  SsetterApp
//
//  Created by anonymous on 5/28/R7.
//

import SwiftUI
import CoreLocation
import UserNotifications

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()

var body: some View {
    ZStack {
        Color.black // 🔲 원하는 배경색 지정
            .ignoresSafeArea() // ✅ 노치 포함 전체 화면을 검정으로 채움

        WebView(url: URL(string: "https://ssetter.ngrok.app")!)
            .ignoresSafeArea(.keyboard) // ✅ 키보드 시 safe area 무시
    }
    .onAppear {
        locationManager.requestPermission()
        requestNotificationPermission()
    }
}

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            if let error = error {
                print("🔴 알림 권한 요청 실패: \(error)")
            } else {
                print("🔔 알림 권한 허용 여부: \(granted)")
            }
        }
    }
}
