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
        WebView(url: URL(string: "https://ssetter.com")!)
            .ignoresSafeArea(.keyboard)
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
