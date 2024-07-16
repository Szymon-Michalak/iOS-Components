//
//  ContentView.swift
//  TextRendererEffect
//
//  Created by Balaji Venkatesh on 13/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var reveal: Bool = false
    @State private var type: RevealRenderer.RevealType = .pixellate
    @State private var revealProgress: CGFloat = 0
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $type) {
                    ForEach(RevealRenderer.RevealType.allCases, id: \.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                
                let apiKey = Text("1734jfJF84019")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .customAttribute(APIKeyAttribute())
                
                Text("Your API Key is \(apiKey)\nDon't share this with anyone.")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundStyle(.gray)
                    .textRenderer(RevealRenderer(type: type, progress: revealProgress))
                    .padding(.vertical, 20)
                
                Button {
                    reveal.toggle()
                    withAnimation(.snappy(duration: 0.4, extraBounce: 0)) {
                        revealProgress = reveal ? 1 : 0
                    }
                } label: {
                    Text(reveal ? "Hide Key" : "Reveal Key")
                        .padding(.horizontal, 25)
                        .padding(.vertical, 2)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.black)
                
                Spacer(minLength: 0)
            }
            .padding(15)
            .navigationTitle("Text Renderer")
        }
    }
}

#Preview {
    ContentView()
}

/// Text Attribute
struct APIKeyAttribute: TextAttribute {
    /// Additional Properties
}

/// Custom Renderer
struct RevealRenderer: TextRenderer, Animatable {
    var type: RevealType = .blur
    var progress: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let allLines = layout.flatMap({ $0 })
        //let allRunns = allLines.flatMap({ $0 })
        
        for line in allLines {
            if let _ = line[APIKeyAttribute.self] {
                var localContext = ctx
                let isBlur = type == .blur
                
                let blurProgress: CGFloat = 5 - (5 * progress)
                let blurFilter = GraphicsContext.Filter
                    .blur(radius: blurProgress)
                
                let pixellateProgress: CGFloat = 5 - (4.999 * progress)
                let pixellateFilter = GraphicsContext.Filter
                    .distortionShader(ShaderLibrary.pixellate(.float(pixellateProgress)), maxSampleOffset: .zero)
                    
                localContext.addFilter(isBlur ? blurFilter : pixellateFilter)
                localContext.draw(line)
            } else {
                var localContext = ctx
                localContext.draw(line)
            }
        }
    }
    
    enum RevealType: String, CaseIterable {
        case blur = "Blur"
        case pixellate = "Pixellate"
    }
}
