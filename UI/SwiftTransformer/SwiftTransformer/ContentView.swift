//
//  ContentView.swift
//  SwiftTransformer
//
//  Created by Balaji Venkatesh on 21/04/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /// View Properties
    @State private var showView: Bool = false
    @State private var selectedColor: DummyColors = .none
    /// Context
    @Environment(\.modelContext) private var context
    /// Stored Colors
    @Query private var storedColors: [ColorModel]
    var body: some View {
        NavigationStack {
            List {
                ForEach(storedColors) { color in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color(color.color).gradient)
                            .frame(width: 35, height: 35)
                        
                        Text(color.name)
                    }
                    .padding(.vertical, 2)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("", systemImage: "trash") {
                            context.delete(color)
                        }
                        .tint(.red)
                    }
                }
            }
            .safeAreaPadding(.top, 15)
            .navigationTitle("My Colors")
            .toolbar {
                Button("Add") { showView.toggle() }
            }
        }
        .sheet(isPresented: $showView) {
            NavigationStack {
                List {
                    Picker("Select", selection: $selectedColor) {
                        ForEach(DummyColors.allCases, id: \.rawValue) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                }
                .navigationTitle("Choose a color")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel", role: .destructive) {
                            showView = false
                            selectedColor = .none
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add") {
                            let colorModel = ColorModel(name: selectedColor.rawValue, color: selectedColor.color)
                            context.insert(colorModel)
                            /// Closing View
                            selectedColor = .none
                            showView = false
                        }
                        .disabled(selectedColor == .none)
                    }
                }
            }
            .interactiveDismissDisabled()
            .presentationDetents([.height(200)])
        }
    }
}

#Preview {
    ContentView()
}

@Model
class ColorModel {
    var name: String
    @Attribute(.transformable(by: ColorTransformer.self)) var color: UIColor
    
    init(name: String, color: Color) {
        self.name = name
        self.color = UIColor(color)
    }
}

/// Custom Transformer for Accepting Color Values
/// Steps,
/// 1. Create your own Custom Transformer
/// 2. Overriding transformedValueClass & allowsReverseTransformation functions is a must
/// 3. Register your transformer in the app's initializer
class ColorTransformer: ValueTransformer {
    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? UIColor else { return nil }
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            return data
        } catch {
            return nil
        }
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        
        do {
            let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data)
            return color
        } catch {
            return nil
        }
    }
    
    override class func transformedValueClass() -> AnyClass {
        return UIColor.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    static func register() {
        ValueTransformer.setValueTransformer(ColorTransformer(), forName: .init("ColorTransformer"))
    }
}

enum DummyColors: String, CaseIterable {
    case red = "Red"
    case blue = "Blue"
    case green = "Green"
    case yellow = "Yellow"
    case purple = "Purple"
    case brown = "Brown"
    case black = "Black"
    case none = "None"
    
    var color: Color {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .brown:
            return .brown
        case .black:
            return .black
        case .none:
            return .clear
        }
    }
}
