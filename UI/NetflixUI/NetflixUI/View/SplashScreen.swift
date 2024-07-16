//
//  SplashScreen.swift
//  NetflixUI
//
//  Created by Balaji Venkatesh on 11/04/24.
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    @Environment(AppData.self) private var appData
    @State private var progress: CGFloat = 0.0
    var body: some View {
        Rectangle()
            .fill(.black)
            .overlay {
                if let jsonURL {
                    LottieView {
                        await LottieAnimation.loadedFrom(url: jsonURL)
                    }
                    .playing(.fromProgress(0, toProgress: progress, loopMode: .playOnce))
                    .animationDidFinish { completed in
                        appData.isSplashFinished = progress != 0 && completed
                    }
                    .frame(width: 600, height: 400)
                    .task {
                        try? await Task.sleep(for: .seconds(0.15))
                        progress = 0.8
                    }
                }
            }
            .ignoresSafeArea()
    }
    
    private var jsonURL: URL? {
        if let bundlePath = Bundle.main.path(forResource: "Logo", ofType: "json") {
            return URL(filePath: bundlePath)
        }
        
        return nil
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
