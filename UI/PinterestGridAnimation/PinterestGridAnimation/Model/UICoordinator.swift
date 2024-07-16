//
//  UICoordinator.swift
//  PinterestGridAnimation
//
//  Created by Balaji Venkatesh on 04/05/24.
//

import SwiftUI

@Observable
class UICoordinator {
    /// Shared View Properties between Home and Detail View
    var scrollView: UIScrollView = .init(frame: .zero)
    var rect: CGRect = .zero
    var selectedItem: Item?
    /// Animation Layer Properties
    var animationLayer: UIImage?
    var animateView: Bool = false
    var hideLayer: Bool = false
    /// Root View Properties
    var hideRootView: Bool = false
    /// Detail View Properties
    var headerOffset: CGFloat = .zero
    
    func createVisibleAreaSnapshot() {
        let renderer = UIGraphicsImageRenderer(size: scrollView.bounds.size)
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: -scrollView.contentOffset.x, y: -scrollView.contentOffset.y)
            scrollView.layer.render(in: ctx.cgContext)
        }
        animationLayer = image
    }
    
    func toogleView(show: Bool, frame: CGRect, post: Item) {
        if show {
            selectedItem = post
            /// Storing View's Rect
            rect = frame
            /// Generating Scrollview's Visible area Snapshot
            createVisibleAreaSnapshot()
            hideRootView = true
            /// Animating View
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.hideLayer = true
            }
        } else {
            /// Closing View
            hideLayer = false
            withAnimation(.easeInOut(duration: 0.3), completionCriteria: .removed) {
                animateView = false
            } completion: {
                DispatchQueue.main.async {
                    /// Resetting Properties
                    self.resetAnimationProperties()
                }
            }
        }
    }
    
    private func resetAnimationProperties() {
        headerOffset = 0
        selectedItem = nil
        animationLayer = nil
        hideRootView = false
    }
}

struct ScrollViewExtractor: UIViewRepresentable {
    var result: (UIScrollView) -> ()
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            if let scrollView = view.superview?.superview?.superview as? UIScrollView {
                result(scrollView)
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
