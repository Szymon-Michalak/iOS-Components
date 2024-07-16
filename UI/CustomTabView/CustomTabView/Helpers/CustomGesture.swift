//
//  CustomGesture.swift
//  CustomTabView
//
//  Created by Balaji Venkatesh on 02/07/24.
//

import SwiftUI

struct CustomGesture: UIGestureRecognizerRepresentable {
    @Binding var isEnabled: Bool
    /// Only Receives Start and End Updates
    var trigger: (Bool) -> ()
    var onChanged: (CGSize, CGPoint) -> ()
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        let view = recognizer.view
        let location = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        
        let offset = CGSize(width: translation.x, height: translation.y)
        
        if recognizer.state == .began {
            trigger(true)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            trigger(false)
        } else {
            onChanged(offset, location)
        }
    }
}
