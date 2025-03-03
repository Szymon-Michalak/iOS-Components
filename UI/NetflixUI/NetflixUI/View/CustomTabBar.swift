//
//  CustomTabBar.swift
//  NetflixUI
//
//  Created by Balaji Venkatesh on 11/04/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(AppData.self) private var appData
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button {
                    appData.activeTab = tab
                } label: {
                    VStack(spacing: 2) {
                        Group {
                            if tab.icon == "Profile" {
                                Image(.iJustine)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 25, height: 25)
                                    .clipShape(.rect(cornerRadius: 4))
                                    .frame(width: 35, height: 35)
                            } else {
                                Image(systemName: tab.icon)
                                    .font(.title3)
                                    .frame(width: 35, height: 35)
                            }
                        }
                        .keyframeAnimator(initialValue: 1, trigger: appData.activeTab) { content, scale in
                            content
                                .scaleEffect(appData.activeTab == tab ? scale : 1)
                        } keyframes: { _ in
                            CubicKeyframe(1.2, duration: 0.2)
                            CubicKeyframe(1, duration: 0.2)
                        }
                        
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .animation(.snappy) { content in
                        content
                            .opacity(appData.activeTab == tab ? 1 : 0.6)
                    }
                    .contentShape(.rect)
                }
                .buttonStyle(NoAnimationButtonStyle())
            }
        }
        .padding(.bottom, 10)
        .padding(.top, 5)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    MainView()
        .environment(AppData())
        .preferredColorScheme(.dark)
}
