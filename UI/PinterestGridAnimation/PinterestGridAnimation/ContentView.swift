//
//  ContentView.swift
//  PinterestGridAnimation
//
//  Created by Balaji Venkatesh on 04/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .toolbar(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
