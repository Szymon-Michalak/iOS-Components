//
//  SwiftTransformerApp.swift
//  SwiftTransformer
//
//  Created by Balaji Venkatesh on 21/04/24.
//

import SwiftUI

@main
struct SwiftTransformerApp: App {
    init() {
        ColorTransformer.register()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: ColorModel.self)
        }
    }
}
