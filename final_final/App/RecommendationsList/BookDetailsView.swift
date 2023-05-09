//
//  BookDetailsView.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Foundation
import SwiftUI

struct BookDetailView: View {
    var book: Book

    @State private var isFavorited = false
    @EnvironmentObject var viewModel: RecommendationsViewModel

    var body: some View {
        NavigationView {
            VStack {
                bookDetails
                LikeButton(isLiked: book.isFavorited) {
                    viewModel.toggleFavourite(for: book, isFavourite: $0)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarColor(backgroundColor: .black, titleColor: .white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    @ViewBuilder
    var bookDetails: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: book.imageURL))
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .aspectRatio(contentMode: .fill)
                    .clipped()

                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("By \(book.author)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Genres: \(book.genresList.prefix(3).joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("Average price: \(book.price)$")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text(book.desc)
                        .font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}
