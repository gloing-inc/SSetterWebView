//
//  LocationManager.swift
//  SsetterApp
//
//  Created by anonymous on 5/29/R7.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestPermission() {
        print("📍 위치 권한 요청 시작")
        locationManager.requestWhenInUseAuthorization()
        // ❌ 바로 requestLocation 호출 X
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        print("📍 위치 권한 상태 변경됨: \(authorizationStatus.rawValue)")

        switch authorizationStatus {
        case .notDetermined:
            print("❓ 아직 권한 요청하지 않음")
        case .restricted:
            print("⛔ 제한됨")
        case .denied:
            print("❌ 거부됨")
        case .authorizedAlways, .authorizedWhenInUse:
            print("✅ 권한 허용됨 → 위치 요청 시작")
            locationManager.requestLocation() // ✅ 이 시점에 위치 요청
        @unknown default:
            print("❗ 알 수 없는 상태")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("📍 위치 업데이트 수신됨: \(locations.first?.coordinate.latitude ?? 0), \(locations.first?.coordinate.longitude ?? 0)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("⚠️ 위치 가져오기 실패: \(error.localizedDescription)")
    }
}
