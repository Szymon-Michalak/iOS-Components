//
//  ContentView.swift
//  RangeSlider
//
//  Created by Balaji Venkatesh on 25/04/24.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var selection: ClosedRange<CGFloat> = 30...50
    var body: some View {
        NavigationStack {
            VStack {
                Text("""
                RangeSliderView(
                    selection: $selection,
                    range: **30...100**,
                    minimumDistance: 10
                )
                
                Selected Range:
                **\(Int(selection.lowerBound)):\(Int(selection.upperBound))**
                """)
                .kerning(1.2)
                .lineSpacing(8)
                .padding(15)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.bottom, 30)
                .padding(.top, 10)
                
                RangeSliderView(
                    selection: $selection,
                    range: 30...100,
                    minimumDistance: 10
                )
                .overlay(alignment: .bottom) {
                    HStack {
                        Text("30")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Text("100")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    .offset(y: 20)
                }
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .navigationTitle("Range Slider")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
        }
    }
}

/// Custom View
struct RangeSliderView: View {
    @Binding var selection: ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primary
    /// View Properties
    @State private var slider1: GestureProperties = .init()
    @GestureState private var isActiveSlider1: Bool = false
    @State private var slider2: GestureProperties = .init()
    @GestureState private var isActiveSlider2: Bool = false
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInitial: Bool = false
    var body: some View {
        GeometryReader { reader in
            let maxSliderWidth = reader.size.width - 30
            let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(tint.tertiary)
                    .frame(height: 5)
                
                /// Sliders
                HStack(spacing: 0) {
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .animation(.snappy(duration: 0.3, extraBounce: 0)) {
                            $0
                                .scaleEffect(isActiveSlider1 ? 1.4 : 1)
                        }
                        .background(alignment: .leading) {
                            Rectangle()
                                .fill(tint)
                                .frame(width: indicatorWidth, height: 5)
                                .offset(x: 15)
                                .allowsHitTesting(false)
                        }
                        .offset(x: slider1.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isActiveSlider1) { _, out, _ in
                                    out = true
                                }
                                .onChanged { value in
                                    /// Calculating Offset
                                    var translation = value.translation.width + slider1.lastStoredOffset
                                    translation = min(max(translation, 0), slider2.offset - minimumDistance)
                                    slider1.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }.onEnded { _ in
                                    /// Storing Previous Offset
                                    slider1.lastStoredOffset = slider1.offset
                                }
                        )
                    
                    Circle()
                        .fill(tint)
                        .frame(width: 15, height: 15)
                        .contentShape(.rect)
                        .animation(.snappy(duration: 0.3, extraBounce: 0)) {
                            $0
                                .scaleEffect(isActiveSlider2 ? 1.4 : 1)
                        }
                        .offset(x: slider2.offset)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .updating($isActiveSlider2) { _, out, _ in
                                    out = true
                                }
                                .onChanged { value in
                                    /// Calculating Offset
                                    var translation = value.translation.width + slider2.lastStoredOffset
                                    translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                                    slider2.offset = translation
                                    
                                    calculateNewRange(reader.size)
                                }.onEnded { _ in
                                    /// Storing Previous Offset
                                    slider2.lastStoredOffset = slider2.offset
                                }
                        )
                }
            }
            .frame(maxHeight: .infinity)
            .task {
                guard !isInitial else { return }
                isInitial = true
                try? await Task.sleep(for: .seconds(0))
                let maxWidth = reader.size.width - 30
                
                /// Converting Selection Range into Offset
                let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                
                slider1.offset = start
                slider1.lastStoredOffset = start
                
                let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                
                slider2.offset = end
                slider2.lastStoredOffset = end
                
                calculateNewRange(reader.size)
            }
        }
        .frame(height: 20)
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset
        
        let maxWidth = size.width - 30
        /// Calculating New Range Values
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth
        
        /// Interpolating Between Upper and Lower Bounds
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)
        
        /// Updating Selection
        selection = newRangeStart...newRangeEnd
    }
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
}

/// Interpolation Technique
extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        /// If Value less than it's Initial Input Range
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            
            /// Linear Interpolation Formula: y1 + ((y2-y1) / (x2-x1)) * (x-x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2-y1) / (x2-x1)) * (x-x1)
                return y
            }
        }
        
        /// If Value Exceeds it's Maximum Input Range
        return outputRange[length]
    }
}

#Preview {
    ContentView()
}
