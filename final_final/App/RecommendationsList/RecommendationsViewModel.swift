//
//  RecommendationsViewModel.swift
//  final_final
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Combine
import CSV
import Foundation
import SwiftUI

final class RecommendationsViewModel: ObservableObject {
    // MARK: - Properties

    let searchTextPrompt = "Look for the book title"
    let csvUrl = "https://firebasestorage.googleapis.com/v0/b/bookshelf-d0a42.appspot.com/o/full-books-new.csv?alt=media&token=1f3c41b3-e17b-439a-a501-8fbf8c9f57ab"

    @Published var books = [Book]()
    @Published var booksForFiltering = [Book]()
    @Published var searchText = ""

    var selectedGenres: [String] = []
    var selectedAuthors: [String] = []
    var booksRecomendations: [Book] = []

    // MARK: - Init

    init() {
        getFilterBooks()
    }

    // MARK: - Actions

    func getFilterBooks() {
        FirebaseStorageManager.downloadFile(from: csvUrl) { data, error in
            if let data = data {
                self.process_books(data: data)
            } else if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
            }
        }
    }

    private func process_books(data: Data) {
        if let csvString = String(data: data, encoding: .utf8) {
            do {
                let csv = try CSVReader(string: csvString, hasHeaderRow: true)
                while let row = csv.next() {
                    let title = row[1]
                    let author = row[2]
                    let desc = row[4]
                    let genresList = row[5]
                    let imageURL = row[9]
                    let price = row[12]

                    let parsedGenresList = getBookGenres(string: genresList)

                    let newBook = Book(imageURL: imageURL,
                                       title: title,
                                       author: author,
                                       price: price,
                                       desc: desc,
                                       genresList: parsedGenresList)

                    if selectedAuthors.contains(row[2]) {
                        if !books.contains(where: { book in book.title == newBook.title }) {
                            books.append(newBook)
                        }
                    }
                    if parsedGenresList.contains(where: { selectedGenres.contains($0) }) {
                        if !books.contains(where: { book in book.title == newBook.title }) {
                            books.append(newBook)
                        }
                    }
                    if booksForFiltering.count >= 200 {
                        break
                    }
                    booksForFiltering.append(newBook)
                }
            } catch {
                print("Error reading CSV file: \(error)")
            }
        } else {
            print("Error parsing CSV")
        }
    }

    private func getBookGenres(string: String) -> [String] {
        let cleanedString = string.replacingOccurrences(of: "[\\[\\]']", with: "", options: .regularExpression)
        return cleanedString.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    func toggleFavourite(for book: Book, isFavourite: Bool) {
        if let index = booksRecomendations.firstIndex(of: book) {
            booksRecomendations[index].isFavorited = isFavourite
            booksRecomendations.sort(by: { $0.isFavorited && !$1.isFavorited })
        }
    }

    func filteringBaseOnUserPreference() -> [Book] {
        var cosineSimilarityTable: [(String, Double)] = []
        for book in booksForFiltering {
            let formStringRelevantData = book.author + " " + book.genresList.joined(separator: " ")
            let userDataForCosineSimilarity = formDataForCosineSimilarity()
            let cosineSimilarityValue = cosineSimilarity(stringA: formStringRelevantData, stringB: userDataForCosineSimilarity)
            cosineSimilarityTable.append((book.title, cosineSimilarityValue))
        }
        let sortedTable = cosineSimilarityTable.sorted { $0.1 > $1.1 }
        let theMostRelevantData = sortedTable.prefix(20)
        var booksItems = booksForFiltering.filter { book in theMostRelevantData.contains(where: { $0.0 == book.title }) }
        booksItems += books.filter { book in !booksItems.contains { $0.title == book.title } }
        booksRecomendations = booksItems
        return booksItems
    }

    func cosineSimilarity(stringA: String, stringB: String) -> Double {
        let wordsA = stringA.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let wordsB = stringB.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        let wordSet = Set(wordsA).union(Set(wordsB))
        let vectorA = wordSet.map { word in wordsA.filter { $0 == word }.count }
        let vectorB = wordSet.map { word in wordsB.filter { $0 == word }.count }
        return cosineSimilarity(vectorA: vectorA, vectorB: vectorB)
    }

    func cosineSimilarity(vectorA: [Int], vectorB: [Int]) -> Double {
        let final_result = zip(vectorA, vectorB).map(*).reduce(0, +)
        let magnitudeA = sqrt(vectorA.map { Double($0 * $0) }.reduce(0, +))
        let magnitudeB = sqrt(vectorB.map { Double($0 * $0) }.reduce(0, +))
        return Double(final_result) / (magnitudeA * magnitudeB)
    }

    func formDataForCosineSimilarity() -> String {
        let row = selectedGenres.joined(separator: " ") + " " + selectedAuthors.joined(separator: " ")
        return row
    }
}
