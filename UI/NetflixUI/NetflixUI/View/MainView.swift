//
//  MainView.swift
//  NetflixUI
//
//  Created by Balaji Venkatesh on 11/04/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Spacer(minLength: 0)
            
            /// Custom Tab Bar
            CustomTabBar()
        }
    }
}

#Preview {
    MainView()
        .preferredColorScheme(.dark)
}
