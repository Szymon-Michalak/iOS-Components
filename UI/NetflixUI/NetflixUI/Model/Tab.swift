//
//  Tab.swift
//  NetflixUI
//
//  Created by Balaji Venkatesh on 11/04/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case new = "New & Hot"
    case account = "My Netflix"
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .new:
            return "play.rectangle.on.rectangle"
        case .account:
            return "Profile"
        }
    }
}
