//
//  ContentView.swift
//  TextSelectionAPI
//
//  Created by Balaji Venkatesh on 24/06/24.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var text: String = ""
    @State private var selection: TextSelection? = .init(insertionPoint: "".startIndex)
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text, selection: $selection)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .frame(height: 150)
                    .background(.background, in: .rect(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 12) {
                        Button("Move Cursor After Hello") {
                            if let range = text.range(of: "Hello") {
                                let endIndex = range.upperBound
                                selection = .init(insertionPoint: endIndex)
                            }
                        }
                        
                        Button("Select Hello") {
                            if let range = text.range(of: "Hello") {
                                selection = .init(range: range)
                            }
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button("Move Cursor to First") {
                            selection = .init(insertionPoint: text.startIndex)
                        }
                        
                        Button("Move Cursor to Last") {
                            selection = .init(insertionPoint: text.endIndex)
                        }
                    }
                    
                    if let selectedTextRange, text[selectedTextRange] == "Hello" || text[selectedTextRange] == "Hello Guys" {
                        
                        let isHello = text[selectedTextRange] == "Hello"
                        let newText = "Hello\(isHello ? " Guys" : "")"
                        
                        Button("Repalce With \(newText)") {
                            text.replaceSubrange(selectedTextRange, with: newText)

                            let startIndex = selectedTextRange.lowerBound
                            let length = newText.count
                            let endIndex = text.index(startIndex, offsetBy: length)
                            let newRange: Range<String.Index> = .init(uncheckedBounds: (startIndex, endIndex))
                            selection = .init(range: newRange)
                        }
                    }
                }
                .font(.system(size: 15))
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .background(.background, in: .rect(cornerRadius: 10))
                .padding(.top, 10)
                .animation(.snappy(duration: 0.25, extraBounce: 0), value: selectedTextRange)
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .navigationTitle("Text Selection API")
            .background(.gray.opacity(0.15))
        }
    }
    
    var selectedTextRange: Range<String.Index>? {
        if let selection, !selection.isInsertion {
            switch selection.indices {
            case .selection(let range):
                return range
            default: return nil
            }
        }
        
        return nil
    }
}

#Preview {
    ContentView()
}
