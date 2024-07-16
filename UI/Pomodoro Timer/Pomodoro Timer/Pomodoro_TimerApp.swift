//
//  Pomodoro_TimerApp.swift
//  Pomodoro Timer
//
//  Created by Balaji Venkatesh on 27/06/24.
//

import SwiftUI

@main
struct Pomodoro_TimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            /// Injecting Model
                .modelContainer(for: Recent.self)
        }
    }
}
