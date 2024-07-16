//
//  ContentView.swift
//  AnimatedCharts
//
//  Created by Balaji Venkatesh on 05/04/24.
//

import SwiftUI
import Charts

struct ContentView: View {
    /// View Properties
    @State private var appDownloads: [Download] = sampleDownloads
    @State private var isAnimated: Bool = false
    @State private var trigger: Bool = false
    @State private var chartType: ChartType = .bar
    var body: some View {
        NavigationStack {
            List {
                Section("Chart Type") {
                    Picker("", selection: $chartType) {
                        ForEach(ChartType.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Demo") {
                    Chart {
                        ForEach(appDownloads) { download in
                            if chartType == .bar {
                                BarMark(
                                    x: .value("Month", download.month),
                                    y: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .foregroundStyle(by: .value("Month", download.month))
                            } else if chartType == .line {
                                LineMark(
                                    x: .value("Month", download.month),
                                    y: .value("Downloads", download.isAnimated ? download.value : 0)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(.green.gradient)
                                .symbol {
                                    Circle()
                                        .fill(.green)
                                        .frame(width: 10, height: 10)
                                }
                                .opacity(download.isAnimated ? 1 : 0)
                            } else {
                                SectorMark(
                                    angle: .value("Downloads", download.isAnimated ? download.value : 0),
                                    innerRadius: .fixed(61),
                                    angularInset: 1
                                )
                                .foregroundStyle(by: .value("Month", download.month))
                            }
                        }
                    }
                    .chartYScale(domain: 0...12000)
                    .frame(height: 250)
                    .chartLegend(chartType == .bar ? .hidden : .visible)
                }
            }
            .navigationTitle("Animated Chart's")
            .onAppear(perform: animateChart)
            .onChange(of: trigger, initial: false) { oldValue, newValue in
                resetChartAnimation()
                animateChart()
            }
            .onChange(of: chartType, { oldValue, newValue in
                appDownloads = sampleDownloads
                resetChartAnimation()
                animateChart()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Trigger") {
                        if appDownloads.count == 6 {
                            /// Adding Extra Dummy Data
                            appDownloads.append(contentsOf: [
                                .init(date: .createDate(1, 2, 24), value: 4700),
                                .init(date: .createDate(1, 3, 24), value: 9700),
                                .init(date: .createDate(1, 4, 24), value: 1700)
                            ])
                        }
                        trigger.toggle()
                    }
                }
            }
        }
    }
    
    // MARK: Animating Chart
    private func animateChart() {
        guard !isAnimated else { return }
        isAnimated = true
        
        $appDownloads.enumerated().forEach { index, element in
            // MARK: Limiting Animation after a certain index
            
//            if index > 5 {
//                element.wrappedValue.isAnimated = true
//            } else {
//                let delay = Double(index) * 0.05
//                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                    withAnimation(.smooth) {
//                        element.wrappedValue.isAnimated = true
//                    }
//                }
//            }
            
            let delay = Double(index) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.smooth) {
                    element.wrappedValue.isAnimated = true
                }
            }
        }
    }
    
    // MARK: Resetting Chart Animation
    private func resetChartAnimation() {
        $appDownloads.forEach { download in
            download.wrappedValue.isAnimated = false
        }
        
        isAnimated = false
    }
    
    enum ChartType: String, CaseIterable {
        case bar = "Bar"
        case line = "Line"
        case pie = "Pie"
    }
}

#Preview {
    ContentView()
}
