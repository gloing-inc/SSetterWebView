// 스플레쉬 관련 클래스

import SwiftUI

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        Group {
            if isActive {
                ContentView() // ✅ 진짜 앱 화면
            } else {
                ZStack {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                    Image("LaunchImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240, height: 128)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}
