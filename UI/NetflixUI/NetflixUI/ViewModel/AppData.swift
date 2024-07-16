//
//  AppData.swift
//  NetflixUI
//
//  Created by Balaji Venkatesh on 11/04/24.
//

import SwiftUI

@Observable
class AppData {
    var isSplashFinished: Bool = false
    var activeTab: Tab = .home
}
