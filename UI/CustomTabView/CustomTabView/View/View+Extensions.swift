//
//  View+Extensions.swift
//  CustomTabView
//
//  Created by Balaji Venkatesh on 02/07/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideTabBar() -> some View {
        self
            .toolbarVisibility(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func loopingWiggle(_ isEnabled: Bool = false) -> some View {
        self
            .symbolEffect(.wiggle.byLayer.counterClockwise, isActive: isEnabled)
    }
}
