//
//  ContentView.swift
//  ExpandableSearchBar
//
//  Created by Balaji Venkatesh on 27/04/24.
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
