//
//  RecentSearchView.swift
//  final_final
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Foundation
import SwiftUI

struct RecentSearchView: View {
    @EnvironmentObject var viewModel: ARViewModel

    var body: some View {
        VStack {
            NavigationStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(), count: 2), spacing: 16) {
                        ForEach(viewModel.booksScanned, id: \.self) { book in
                            NavigationLink(destination: BookDetailView(book: book)) {
                                AsyncImage(url: URL(string: book.imageURL)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                                .task {
                                    if let url = URL(string: book.imageURL) {
                                        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
                                        let session = URLSession.shared
                                        let task = session.dataTask(with: request)
                                        task.resume()
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Recent search")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
