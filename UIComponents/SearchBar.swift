import SwiftUI

/// A reusable search bar component with animation and state management.
struct SearchBar: View {
    
    private enum Constants {
        static let animationDuration: Double = 0.2
        static let iconOpacity: Double = 0.5
        static let verticalPadding: CGFloat = 8.0
        static let iconFontSize: CGFloat = 20.0
        static let clearButtonColor: Color = .gray
    }
    
    // MARK: - Stored Properties
    
    @State private var searchText: String = ""
    @State private var isEditing: Bool = false
    
    /// A closure that gets called when the search text changes.
    var onTextChanged: (String) -> Void
    
    // MARK: - Views

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: Constants.iconFontSize))
                .foregroundColor(.primary.opacity(Constants.iconOpacity))
            
            TextField(
                "Search for snippets...",
                text: $searchText,
                onEditingChanged: { editing in
                    withAnimation {
                        self.isEditing = editing
                    }
                },
                onCommit: {
                    onTextChanged(searchText)
                    isEditing = false
                }
            )
            .textFieldStyle(PlainTextFieldStyle())
            .padding(.vertical, Constants.verticalPadding)
            .onChange(of: searchText) { newText in
                onTextChanged(newText)
            }
            
            if isEditing {
                Button(action: {
                    searchText = ""
                    isEditing = false
                    onTextChanged(searchText)
                }) {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Constants.clearButtonColor)
                        .padding(.leading, Constants.verticalPadding)
                }
                .buttonStyle(PlainButtonStyle())
                .transition(.opacity)
                .animation(.easeIn(duration: Constants.animationDuration), value: isEditing)
            }
        }
        .padding(.horizontal, Constants.verticalPadding)
        .background(Color(.systemGray5))
        .cornerRadius(10.0)
    }
}

// MARK: - Preview

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar { _ in }
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
