//
//  Item.swift
//  StackedCardsView
//
//  Created by Balaji Venkatesh on 14/05/24.
//

import SwiftUI

struct Item: Identifiable{
    var id: UUID = .init()
    var logo: String
    var title: String
    var description: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
}

var items: [Item] = [
    Item(logo: "", title: ""),
    Item(logo: "Amazon", title: "Amazon"),
    Item(logo: "Youtube", title: "Youtube"),
    Item(logo: "Dribbble", title: "Dribbble"),
    Item(logo: "Apple", title: "Apple"),
    Item(logo: "Patreon", title: "Patreon"),
    Item(logo: "Instagram", title: "Instagram"),
    Item(logo: "Netflix", title: "Netflix"),
    Item(logo: "Photoshop", title: "Photoshop"),
    Item(logo: "Figma", title: "Figma")
]
