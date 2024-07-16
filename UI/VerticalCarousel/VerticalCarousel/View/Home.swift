//
//  Home.swift
//  VerticalCarousel
//
//  Created by Balaji Venkatesh on 02/06/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(cards) { card in
                        CardView(card)
                            .frame(width: 220, height: 150)
                            .visualEffect { content, geometryProxy in
                                content
                                    .offset(x: -150)
                                    .rotationEffect(
                                        .init(degrees: cardRotation(geometryProxy)),
                                        anchor: .trailing
                                    )
                                    .offset(x: 100, y: -geometryProxy.frame(in: .scrollView(axis: .vertical)).minY)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.vertical, (size.height * 0.5) - (size == .zero ? 0 : 75))
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .background {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: size.height, height: size.height)
                    .offset(x: size.height / 2)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Button(action: {}, label: {
                    Image(systemName: "arrow.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color.primary)
                })
                
                Text("Total")
                    .font(.title3.bold())
                    .padding(.top, 10)
                
                Text("$998.80")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Choose a card")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .padding(15)
            
            Button(action: {}, label: {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.white, .green)
                    .contentShape(.circle)
            })
            .offset(x: (size.width - 330) / 2, y: (size.height / 2) - 30)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ card: Card) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(card.color.gradient)
            
            /// Card Details
            VStack(alignment: .leading, spacing: 10) {
                Image(.visa)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40)
                
                Spacer(minLength: 0)
                
                HStack(spacing: 0) {
                    ForEach(0..<3, id: \.self) { _ in
                        Text("****")
                        Spacer(minLength: 0)
                    }
                    
                    Text(card.number)
                        .offset(y: -2)
                }
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.bottom, 10)
                
                HStack {
                    Text(card.name)
                    
                    Spacer(minLength: 0)
                    
                    Text(card.date)
                }
                .font(.caption.bold())
                .foregroundStyle(.white)
            }
            .padding(25)
        }
    }
    
    /// Card Rotation
    func cardRotation(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = proxy.size.height
        
        let progress = minY / height
        let angleForEachCard: CGFloat = -50
        let cappedProgress = progress < 0 ? min(max(progress, -3), 0) : max(min(progress, 3), 0)
        
        return cappedProgress * angleForEachCard
    }
}

#Preview {
    ContentView()
}
