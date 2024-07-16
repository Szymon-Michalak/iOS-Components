//
//  SharedModel.swift
//  ZoomTransitions
//
//  Created by Balaji Venkatesh on 09/07/24.
//

import SwiftUI
import AVKit

@Observable
class SharedModel {
    var videos: [Video] = files
    
    /// Generates Thumbnail Image from the video URL.
    func generateThumbnail(_ video: Binding<Video>, size: CGSize) async {
        do {
            let asset = AVURLAsset(url: video.wrappedValue.fileURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            
            let cgImage = try await generator.image(at: .zero).image
            guard let deviceColorBasedImage = cgImage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else { return }
            
            let thumbnail = UIImage(cgImage: deviceColorBasedImage)
            await MainActor.run {
                video.wrappedValue.thumbnail = thumbnail
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
