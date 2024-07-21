import SwiftUI

/// A custom shape representing a drop pin.
struct DropPin: Shape {
    
    // MARK: - Properties
    
    /// The start angle for the arc of the drop pin.
    var startAngle: Angle = .degrees(180)
    
    /// The end angle for the arc of the drop pin.
    var endAngle: Angle = .degrees(0)
    
    // MARK: - Methods
    
    /**
     Creates a path for the drop pin shape within the specified rectangle.
     
     - Parameter rect: The rectangle in which to draw the path.
     - Returns: A path representing the drop pin shape.
     
     - Usage:
     ```swift
     DropPin()
         .fill(Color.red)
         .frame(width: 100, height: 150)
     ```
     
     - Time Complexity: O(1)
     - Space Complexity: O(1)
     - Use Cases: Creating custom shapes for unique UI elements in SwiftUI.
     - Dependencies: SwiftUI
     - Swift Version: 5.3+
     - Platform: iOS 13.0+
     */
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(
            x: rect.midX,
            y: rect.maxY
        ))
        path.addCurve(
            to: CGPoint(
                x: rect.minX,
                y: rect.midY
            ),
            control1: CGPoint(
                x: rect.midX,
                y: rect.maxY
            ),
            control2: CGPoint(
                x: rect.minX,
                y: rect.midY + rect.height / 4
            )
        )
        path.addArc(
            center: CGPoint(
                x: rect.midX,
                y: rect.midY
            ),
            radius: rect.width / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.addCurve(
            to: CGPoint(
                x: rect.midX,
                y: rect.maxY
            ),
            control1: CGPoint(
                x: rect.maxX,
                y: rect.midY + rect.height / 4
            ),
            control2: CGPoint(
                x: rect.midX,
                y: rect.maxY
            )
        )
        
        return path
    }
}

// MARK: - Usage Example

struct ContentView: View {
    var body: some View {
        DropPin()
            .fill(Color.red)
            .frame(width: 100, height: 150)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
