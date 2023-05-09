//
//  RecommendationsView.swift
//  final_final
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Foundation
import SwiftUI

struct RecommendationsView: View {
    // MARK: - Properties

    @EnvironmentObject var viewModel: RecommendationsViewModel

    // MARK: - Computed Properties

    var filteredBooks: [Book] {
        if viewModel.searchText.isEmpty {
            return viewModel.booksRecomendations
        } else {
            return viewModel.booksRecomendations.filter { $0.title.localizedCaseInsensitiveContains(viewModel.searchText) }
        }
    }

    // MARK: - Body

    var body: some View {
        VStack {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    LabelledDivider(label: "Best choice for you")
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
                        ForEach(filteredBooks.prefix(10), id: \.self) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                AsyncImage(url: URL(string: book.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    LabelledDivider(label: "You might like")
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
                        ForEach(filteredBooks.suffix(8), id: \.self) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                AsyncImage(url: URL(string: book.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }

                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Bookshelf")
                .navigationBarTitleDisplayMode(.inline)
            }
            .searchable(text: $viewModel.searchText, prompt: viewModel.searchTextPrompt)
            .onAppear {
                _ = viewModel.filteringBaseOnUserPreference()
            }
        }
    }
}
