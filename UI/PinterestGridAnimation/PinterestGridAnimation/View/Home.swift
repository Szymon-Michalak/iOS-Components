//
//  Home.swift
//  PinterestGridAnimation
//
//  Created by Balaji Venkatesh on 04/05/24.
//

import SwiftUI

struct Home: View {
    /// UI Properties
    var coordinator: UICoordinator = .init()
    @State private var posts: [Item] = sampleImages
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 15) {
                Text("Welcome Back!")
                    .font(.largeTitle.bold())
                    .padding(.vertical, 10)
                
                /// Grid Image View
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                    ForEach(posts) { post in
                        PostCardView(post)
                    }
                }
            }
            .padding(15)
            .background(ScrollViewExtractor {
                coordinator.scrollView = $0
            })
        }
        .opacity(coordinator.hideRootView ? 0 : 1)
        .scrollDisabled(coordinator.hideRootView)
        .allowsHitTesting(!coordinator.hideRootView)
        .overlay {
            Detail()
                .environment(coordinator)
                .allowsHitTesting(coordinator.hideLayer)
        }
        .background(.gray.opacity(0.15))
    }
    
    /// Post Card View
    @ViewBuilder
    func PostCardView(_ post: Item) -> some View {
        GeometryReader {
            let frame = $0.frame(in: .global)
            
            ImageView(post: post)
                .clipShape(.rect(cornerRadius: 10))
                .contentShape(.rect(cornerRadius: 10))
                .onTapGesture {
                    coordinator.toogleView(show: true, frame: frame, post: post)
                }
        }
        .frame(height: 220)
    }
}

#Preview {
    ContentView()
}
