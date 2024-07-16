//
//  Home.swift
//  CustomTabView
//
//  Created by Balaji Venkatesh on 02/07/24.
//

import SwiftUI

struct Home: View {
    @Environment(TabProperties.self) private var properties
    var body: some View {
        @Bindable var bindings = properties
        NavigationStack {
            List {
                Toggle("Edit Tab Locations", isOn: $bindings.editMode)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
