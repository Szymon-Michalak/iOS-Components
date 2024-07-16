//
//  Detail.swift
//  PinterestGridAnimation
//
//  Created by Balaji Venkatesh on 04/05/24.
//

import SwiftUI

struct Detail: View {
    @Environment(UICoordinator.self) private var coordinator
    var body: some View {
        GeometryReader {
            let size = $0.size
            let animateView = coordinator.animateView
            let hideLayer = coordinator.hideLayer
            let rect = coordinator.rect
            
            /// For Three Column Grid View
            /// let anchorX = (coordinator.rect.minX / size.width) > 0.5 ? 1.0 : ((coordinator.rect.minX / size.width) > 0.25 ? 0.5 : 0.0)
            let anchorX = (coordinator.rect.minX / size.width) > 0.5 ? 1.0 : 0.0
            /// For Two Column Grid View
            let scale = size.width / coordinator.rect.width
            
            /// 15 - Horizontal Padding Applied in the Root View.
            /// For Two Column Grid View
            let offsetX = animateView ? (anchorX > 0.5 ? 15 : -15) * scale : 0
            /// For Three Column Grid View
            /// let offsetX = animateView && anchorX != 0.5 ? (anchorX > 0.5 ? 15 : -15) * scale : 0
            let offsetY = animateView ? -coordinator.rect.minY * scale : 0
            
            let detailHeight: CGFloat = rect.height * scale
            let scrollContentHeight: CGFloat = size.height - detailHeight
            
            if let image = coordinator.animationLayer, let post = coordinator.selectedItem {
                if !hideLayer {
                    Image(uiImage: image)
                        .scaleEffect(animateView ? scale : 1, anchor: .init(x: anchorX, y: 0))
                        .offset(x: offsetX, y: offsetY)
                        .offset(y: animateView ? -coordinator.headerOffset : 0)
                        .opacity(animateView ? 0 : 1)
                        .transition(.identity)
                }
                
                ScrollView(.vertical) {
                    ScrollContent()
                        .safeAreaInset(edge: .top, spacing: 0) {
                            Rectangle()
                                .fill(.clear)
                                .frame(height: detailHeight)
                                .offsetY { offset in
                                    coordinator.headerOffset = max(min(-offset, detailHeight), 0)
                                }
                        }
                }
                .scrollDisabled(!hideLayer)
                .contentMargins(.top, detailHeight, for: .scrollIndicators)
                .background {
                    Rectangle()
                        .fill(.background)
                        .padding(.top, detailHeight - coordinator.headerOffset)
                }
                .animation(.easeInOut(duration: 0.3).speed(1.5)) {
                    $0
                        .offset(y: animateView ? 0 : scrollContentHeight)
                        .opacity(animateView ? 1 : 0)
                }
                
                /// Hero Kinda View
                ImageView(post: post)
                    .allowsHitTesting(false)
                    .frame(
                        width: animateView ? size.width : rect.width,
                        height: animateView ? rect.height * scale : rect.height
                    )
                    .clipShape(.rect(cornerRadius: animateView ? 0 : 10))
                    .overlay(alignment: .top, content: {
                        HeaderActions(post)
                            .offset(y: coordinator.headerOffset)
                            .padding(.top, safeArea.top)
                    })
                    .offset(x: animateView ? 0 : rect.minX, y: animateView ? 0 : rect.minY)
                    .offset(y: animateView ? -coordinator.headerOffset : 0)
            }
        }
        .ignoresSafeArea()
    }
    
    /// Scroll Content
    @ViewBuilder
    func ScrollContent() -> some View {
        /// YOUR SCROLL CONTENT
        DummyContent()
    }
    
    /// Header Actions
    @ViewBuilder
    func HeaderActions(_ post: Item) -> some View {
        HStack {
            Spacer(minLength: 0)
            
            if coordinator.hideLayer {
                Button(action: { coordinator.toogleView(show: false, frame: .zero, post: post) }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.primary, .bar)
                        .padding(10)
                        .contentShape(.rect)
                })
                .transition(.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: coordinator.hideLayer)
    }
}

#Preview {
    ContentView()
}
