//
//  ContentView.swift
//  BookCard
//
//  Created by Balaji Venkatesh on 06/04/24.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var progress: CGFloat = 0.2
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
                    **OpenableBookView**(config: .init(progress: progress)) { size in
                        **FrontView(size)**
                    } insideLeft: { size in
                        **LeftView()**
                    } insideRight: { size in
                        **RightView()**
                    }
                    """
                )
                .font(.system(size: 14))
                .kerning(1)
                .lineSpacing(5)
                .padding(15)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.bottom, 25)
                
                OpenableBookView(config: .init(progress: progress)) { size in
                    FrontView(size)
                } insideLeft: { size in
                    LeftView()
                } insideRight: { size in
                    RightView()
                }
                
                HStack(spacing: 12) {
                    Slider(value: $progress)
                    
                    Button("Toggle") {
                        withAnimation(.bouncy(duration: 0.8)) {
                            progress = (progress == 1.0 ? 0.2 : 1.0)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(10)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.vertical, 50)
            }
            .padding(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
            .navigationTitle("Book View")
        }
    }
    
    /// Front View
    @ViewBuilder
    func FrontView(_ size: CGSize) -> some View {
        Image(.book1)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .offset(y: 10)
            .frame(width: size.width, height: size.height)
    }
    
    /// Left View
    @ViewBuilder
    func LeftView() -> some View {
        VStack(spacing: 5) {
            Image(.author1)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(.circle)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 5, y: 5)
            
            Text("Tamara Bundy")
                .fontWidth(.condensed)
                .fontWeight(.bold)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
    
    /// Right View
    @ViewBuilder
    func RightView() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.system(size: 13))
            
            Text("Tamara Bundy’s beautifully written debut celebrates the wonder and power of friendship: how it can be found when we least expect it and make any place a home.")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.background)
    }
}

/// Interactive Book Card View
struct OpenableBookView<Front: View, InsideLeft: View, InsideRight: View>: View, Animatable {
    var config: Config = .init()
    @ViewBuilder var front: (CGSize) -> Front
    @ViewBuilder var insideLeft: (CGSize) -> InsideLeft
    @ViewBuilder var insideRight: (CGSize) -> InsideRight
    
    var animatableData: CGFloat {
        get { return config.progress }
        set { config.progress = newValue }
    }
    var body: some View {
        GeometryReader {
            let size = $0.size
            /// Limitting Progress btw 0-1
            /// NOTE: If you want bouncing effect update the max limit from 1 to 1.1
            let progress = max(min(config.progress, 1.1), 0)
            let rotation = progress * -180
            let cornerRadius = config.cornerRadius
            let shadowColor = config.shadowColor
            
            ZStack {
                insideRight(size)
                    .frame(width: size.width, height: size.height)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: cornerRadius,
                            topTrailingRadius: cornerRadius
                        )
                    )
                    .shadow(color: shadowColor.opacity(0.1 * progress), radius: 5, x: 5, y: 0)
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(config.dividerBackground.shadow(.inner(color: shadowColor.opacity(0.15), radius: 2)))
                            .frame(width: 6)
                            .offset(x: -3)
                            .clipped()
                    }
                    .allowsHitTesting(-rotation > 90)
                
                front(size)
                    .frame(width: size.width, height: size.height)
                    /// Disabling Interaction Once it's flipped
                    .allowsHitTesting(-rotation < 90)
                    .overlay {
                        if -rotation > 90 {
                            insideLeft(size)
                                .frame(width: size.width, height: size.height)
                                .scaleEffect(x: -1)
                                .transition(.identity)
                        }
                    }
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: cornerRadius,
                            topTrailingRadius: cornerRadius
                        )
                    )
                    .shadow(color: shadowColor.opacity(0.1), radius: 5, x: 5, y: 0)
                    .rotation3DEffect(
                        .init(degrees: rotation),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        perspective: 0.3
                    )
            }
            .offset(x: (config.width / 2) * progress)
        }
        .frame(width: config.width, height: config.height)
    }
    
    /// Configuration
    struct Config {
        var width: CGFloat = 150
        var height: CGFloat = 200
        var progress: CGFloat = 0
        var cornerRadius: CGFloat = 10
        var dividerBackground: Color = .white
        var shadowColor: Color = .black
    }
}

#Preview {
    ContentView()
}
