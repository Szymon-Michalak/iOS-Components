//
//  Home.swift
//  ZoomTransitions
//
//  Created by Balaji Venkatesh on 09/07/24.
//

import SwiftUI

struct Home: View {
    var screenSize: CGSize
    @Namespace private var animation
    @Environment(SharedModel.self) private var sharedModel
    var body: some View {
        @Bindable var bindings = sharedModel
        
        VStack(spacing: 0) {
            /// Header View
            HeaderView()
            
            ScrollView(.vertical) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2), spacing: 10) {
                    ForEach($bindings.videos) { $video in
                        /// Card View
                        NavigationLink(value: video) {
                            CardView($video)
                                .environment(sharedModel)
                                .frame(height: screenSize.height * 0.4)
                                .matchedTransitionSource(id: video.id, in: animation) {
                                    $0
                                        .background(.clear)
                                        .clipShape(.rect(cornerRadius: 15))
                                }
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                }
                .padding(15)
            }
        }
        .navigationDestination(for: Video.self) { video in
            DetailView(video: video, animation: animation)
                .environment(sharedModel)
                .toolbarVisibility(.hidden, for: .navigationBar)
        }
    }
    
    /// Header View
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }
            
            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .foregroundStyle(Color.primary)
        .padding(15)
        .background(.ultraThinMaterial)
    }
    
    /// Card View
    @ViewBuilder
    func CardView(_ video: Binding<Video>) -> some View {
        GeometryReader {
            let size = $0.size
            
            if let thumbnail = video.wrappedValue.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.fill)
                    .task(priority: .high) {
                        await sharedModel.generateThumbnail(video, size: screenSize)
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}

/// Custom Button Style
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
