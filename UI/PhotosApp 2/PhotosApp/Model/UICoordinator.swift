//
//  UICoordinator.swift
//  PhotosApp
//
//  Created by Balaji Venkatesh on 08/05/24.
//

import SwiftUI

@Observable
class UICoordinator {
    var items: [Item] = sampleItems.compactMap({
        Item(title: $0.title, image: $0.image, previewImage: $0.image)
    })
    /// Animation Properties
    var selectedItem: Item?
    var animateView: Bool = false
    var showDetailView: Bool = false
    /// Scroll Positions
    var detailScrollPosition: String?
    
    func didDetailPageChanged() {
        if let updatedItem = items.first(where: { $0.id == detailScrollPosition }) {
            selectedItem = updatedItem
        }
    }
    
    func toggleView(show: Bool) {
        if show {
            detailScrollPosition = selectedItem?.id
            withAnimation(.easeInOut(duration: 2), completionCriteria: .removed) {
                animateView = true
            } completion: {
                self.showDetailView = true
            }
        } else {
            showDetailView = false
            withAnimation(.easeInOut(duration: 2), completionCriteria: .removed) {
                animateView = false
            } completion: {
                self.resetAnimationProperties()
            }
        }
    }
    
    func resetAnimationProperties() {
        selectedItem = nil
        detailScrollPosition = nil
    }
}
