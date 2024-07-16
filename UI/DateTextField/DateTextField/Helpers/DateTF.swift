//
//  DateTF.swift
//  DateTextField
//
//  Created by Balaji Venkatesh on 02/05/24.
//

import SwiftUI

struct DateTF: View {
    /// Config
    var components: DatePickerComponents = [.date, .hourAndMinute]
    @Binding var date: Date
    var formattedString: (Date) -> String
    /// View Properties
    @State private var viewID: String = UUID().uuidString
    @FocusState private var isActive
    var body: some View {
        TextField(viewID, text: .constant(formattedString(date)))
            .focused($isActive)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isActive = false
                    }
                    .tint(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .overlay {
                AddInputViewToTF(id: viewID) {
                    /// SwiftUI Date Picker
                    DatePicker("", selection: $date, displayedComponents: components)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                .onTapGesture {
                    isActive = true
                }
            }
    }
}

fileprivate struct AddInputViewToTF<Content: View>: UIViewRepresentable {
    var id: String
    @ViewBuilder var content: Content
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let window = view.window, let textField = window.allSubViews(type: UITextField.self).first(where: { $0.placeholder == id }) {
                textField.tintColor = .clear
                
                /// Converting SwiftUI View to UIKit View
                let hostView = UIHostingController(rootView: content).view!
                hostView.backgroundColor = .clear
                hostView.frame.size = hostView.intrinsicContentSize
                
                /// Adding as InputView
                textField.inputView = hostView
                textField.reloadInputViews()
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {  }
}

fileprivate extension UIView {
    func allSubViews<T: UIView>(type: T.Type) -> [T] {
        var resultViews = subviews.compactMap({ $0 as? T })
        for view in subviews { resultViews.append(contentsOf: view.allSubViews(type: type)) }
        return resultViews
    }
}

#Preview {
    ContentView()
}
