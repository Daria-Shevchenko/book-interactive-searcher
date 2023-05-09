//
//  Book.swift
//  final_final
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Foundation

final class Book: Identifiable, Hashable {
    let id: UUID
    let imageURL: String
    var title: String
    var author: String
    var price: String
    var desc: String

    var genresList: [String]

    var isFavorited: Bool

    init(id: UUID = UUID(),
         imageURL: String,
         title: String,
         author: String,
         price: String,
         desc: String,
         genresList: [String],
         isFavorited: Bool = false) {
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.author = author
        self.price = price.isEmpty ? "3.0" : price
        self.desc = desc
        self.genresList = genresList
        self.isFavorited = isFavorited
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}
