//
//  ContentView.swift
//  StackedCardsView
//
//  Created by Balaji Venkatesh on 14/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            GeometryReader { _ in
                Image(.wallpaper)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            Home()
        }
        .environment(\.colorScheme, .dark)
    }
}

#Preview {
    ContentView()
}
