//
//  ContentView.swift
//  HackerText
//
//  Created by Balaji Venkatesh on 19/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var trigger: Bool = false
    @State private var text = "Hello Guys!"
    @State private var transition: Int = 1
    @State private var speed: CGFloat = 0.06
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                HackerTextView(
                    text: text,
                    trigger: trigger,
                    transition: transition == 0 ? .identity : transition == 1 ? .interpolate : .numericText(),
                    speed: speed
                )
                .font(.largeTitle.bold())
                .lineLimit(2)
                .frame(height: 200, alignment: .top)
                
                VStack(spacing: 15) {
                    Picker("", selection: $transition) {
                        Text("Identity")
                            .tag(0)
                        Text("Interpolate")
                            .tag(1)
                        Text("NumericText")
                            .tag(2)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Speed:")
                        .font(.callout)
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -15)
                        .padding(.top, 10)
                    
                    Slider(value: $speed, in: 0.01...0.1)
                    
                    Button(action: {
                        if text == "Hello Guys!" {
                            text = "This is Hacker\nText View."
                        } else if text == "This is Hacker\nText View." {
                            text = "Made With SwiftUI\nBy @Kavsoft"
                        } else {
                            text = "Hello Guys!"
                        }
                        
                        /// OR
                        /// trigger.toggle()
                    }, label: {
                        Text("Trigger")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 2)
                    })
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .frame(maxWidth: .infinity)
                }
                .padding(15)
                .background(.bar, in: .rect(cornerRadius: 25))
                .padding(.top, 10)
            }
            .padding(15)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ContentView()
}
