//
//  Home.swift
//  StackedCardsView
//
//  Created by Balaji Venkatesh on 14/05/24.
//

import SwiftUI

struct Home: View {
    @State private var scrollID: UUID?
    var body: some View {
        StackedCards(items: items, stackedDisplayCount: 2, opacityDisplayCount: 0, disablesOpacityEffect: true, itemHeight: 70) { item in
            CardView(item)
        }
        .safeAreaPadding(15)
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ item: Item) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.yellow.gradient)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4, content: {
                Text(item.title)
                    .font(.callout)
                    .fontWeight(.bold)
                
                Text(item.description)
                    .font(.caption)
                    .lineLimit(1)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.black)
        .padding(10)
        .frame(maxHeight: .infinity)
        .background(.white)
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 2)
    }
}

#Preview {
    ContentView()
}
