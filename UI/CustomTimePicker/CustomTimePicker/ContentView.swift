//
//  ContentView.swift
//  CustomTimePicker
//
//  Created by Balaji Venkatesh on 27/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 30
    @State private var seconds: Int = 25
    var body: some View {
        NavigationStack {
            VStack {
                TimePicker(hour: $hours, minutes: $minutes, seconds: $seconds)
                    .padding(15)
                    .background(.white, in: .rect(cornerRadius: 10))
                
                Text("""
                TimePicker(
                    **style: .init(.bar)**,
                    **hour: $hours**,
                    **minutes: $minutes**,
                    **seconds: $seconds**
                )
                """)
                .kerning(1.5)
                .lineSpacing(5)
                .font(.callout)
                .foregroundStyle(.black.opacity(0.7))
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white, in: .rect(cornerRadius: 10))
                
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)
            .padding(15)
            .navigationTitle("Custom Time Picker")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
        }
    }
}

#Preview {
    ContentView()
}
