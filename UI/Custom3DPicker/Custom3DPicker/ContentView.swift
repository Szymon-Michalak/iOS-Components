//
//  ContentView.swift
//  Custom3DPicker
//
//  Created by Balaji Venkatesh on 05/07/24.
//

import SwiftUI

let pickerValues: [String] = [
    "SwiftUI", "UIKit", "AVKit", "WidgetKit", "LiveActivities", "CoreImage", "AppIntents"
]

let pickerValues1: [String] = [
    "iOS 17+ Projects", "iOS 16+ Projects", "iOS 15+ Projects", "macOS 13+ Projects", "visionOS 1.0+ Projects"
]

let pickerValues2: [String] = [
    "WWDC 24", "WWDC 23", "WWDC 21", "WWDC 20", "WWDC 19"
]

struct ContentView: View {
    @State private var config: PickerConfig = .init(text: "SwiftUI")
    @State private var config1: PickerConfig = .init(text: "iOS 17+ Projects")
    @State private var config2: PickerConfig = .init(text: "WWDC 24")
    var body: some View {
        NavigationStack {
            List {
                Section("Configuration") {
                    Button {
                        config.show.toggle()
                    } label: {
                        HStack {
                            Text("Framework")
                                .foregroundStyle(.gray)
                            
                            Spacer(minLength: 0)
                            
                            SourcePickerView(config: $config)
                        }
                    }
                    
                    Button {
                        config1.show.toggle()
                    } label: {
                        HStack {
                            Text("Projects")
                                .foregroundStyle(.gray)
                            
                            Spacer(minLength: 0)
                            
                            SourcePickerView(config: $config1)
                        }
                    }
                    
                    Button {
                        config2.show.toggle()
                    } label: {
                        HStack {
                            Text("Year")
                                .foregroundStyle(.gray)
                            
                            Spacer(minLength: 0)
                            
                            SourcePickerView(config: $config2)
                        }
                    }
                }
            }
            .navigationTitle("Custom Picker")
        }
        .customPicker($config, items: pickerValues)
        .customPicker($config1, items: pickerValues1)
        .customPicker($config2, items: pickerValues2)
    }
}

#Preview {
    ContentView()
}
