//
//  ContentView.swift
//  FlipClockAnimation
//
//  Created by Balaji Venkatesh on 28/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var timer: CGFloat = 0
    @State private var count: Int = 0
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 10) {
                    FlipClockTextEffect(
                        value: .constant(count / 10 % 6),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 90,
                        cornerRadius: 20,
                        foreground: .black,
                        background: .white
                    )
                    
                    FlipClockTextEffect(
                        value: .constant(count % 10),
                        size: CGSize(
                            width: 100,
                            height: 150
                        ),
                        fontSize: 90,
                        cornerRadius: 20,
                        foreground: .black,
                        background: .white
                    )
                }
                .onReceive(Timer.publish(every: 0.01, on: .current, in: .common).autoconnect(), perform: { _ in
                    timer += 0.01
                    if timer >= 20 { timer = 0 }
                    count = Int(timer)
                })
                
                Text("This is a 20s Loop Timer.")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding(.top, 10)
            }
            .padding()
            .navigationTitle("Flip Clock Effect")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
