//
//  ContentView.swift
//  SsetterApp
//
//  Created by anonymous on 5/28/R7.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(url: URL(string: "https://ssetter.com")!)
            .ignoresSafeArea(.keyboard) // 키보드만 무시
    }
}

#Preview {
    ContentView()
}
