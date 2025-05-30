//
//  SsetterAppApp.swift
//  SsetterApp
//
//  Created by anonymous on 5/28/R7.
//

import SwiftUI

@main
struct SsetterAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
