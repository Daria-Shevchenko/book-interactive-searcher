//
//  SelectingPreferenceViewModel.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import Combine
import CSV
import Foundation
import Swinject

final class SelectingPreferenceViewModel: ObservableObject {
    // MARK: - Properties

    let titleGenre = "Choose your favorite book genres"
    let titleAuthor = "Choose your favorite book authors"

    let genresURL = "https://firebasestorage.googleapis.com/v0/b/bookshelf-d0a42.appspot.com/o/all-genres.csv?alt=media&token=b1fa5650-316e-400c-a960-8fb5f40e6c57"

    let authorsURL = "https://firebasestorage.googleapis.com/v0/b/bookshelf-d0a42.appspot.com/o/all-authors.csv?alt=media&token=6ff4993b-d29e-43d3-b0e1-c726a9fb539c"

    @Published var genres = [Genre]()
    @Published var authors = [String]()
    @Published var selectedGenres: [String] = []
    @Published var selectedAuthors: [String] = []

    var selectedAuthorsPublisher: AnyPublisher<[String], Never> {
        $selectedAuthors.eraseToAnyPublisher()
    }

    // MARK: - Computed Properties

    var genresToDisplay: [[String]] {
        let randomGenres = Array(genres.prefix(200))
        let genresName = randomGenres.map { genre in
            genre.genreName
        }
        return chunkStrings(genresName)
    }

    var authorsToDisplay: [[String]] {
        let randomAuthors = Array(authors.prefix(200))
        return chunkStrings(randomAuthors)
    }

    // MARK: - Init

    init() {
        getGenres()
        getAuthors()
    }

    // MARK: - Actions

    private func downloadAndParseCSV(from url: String, completion: @escaping ([[String]]) -> Void) {
        FirebaseStorageManager.downloadFile(from: url) { data, error in
            if let data = data {
                if let csvString = String(data: data, encoding: .utf8) {
                    do {
                        let csv = try CSVReader(string: csvString, hasHeaderRow: true)
                        var rows: [[String]] = []
                        while let row = csv.next() {
                            let values = row.filter { !$0.isEmpty }
                            if !values.isEmpty {
                                rows.append(values)
                            }
                        }
                        completion(rows)
                    } catch {
                        print("Error reading CSV file: \(error)")
                    }
                } else {
                    print("Error parsing CSV")
                }
            } else if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
            }
        }
    }

    private func getGenres() {
        downloadAndParseCSV(from: genresURL) { [weak self] rows in
            let genres = rows.map { $0[0] }
            let newGenres = genres.map { Genre(genreName: $0) }
            self?.genres = newGenres
        }
    }

    private func getAuthors() {
        downloadAndParseCSV(from: authorsURL) { [weak self] rows in
            let authors = rows.map { $0[0] }
            self?.authors = authors
        }
    }

    func chunkStrings(_ strings: [String]) -> [[String]] {
        var chunks: [[String]] = []
        var currentChunk: [String] = []
        var currentChunkCharCount = 0

        for string in strings {
            let stringCharCount = string.count

            if currentChunkCharCount + stringCharCount <= 27 {
                currentChunk.append(string)
                currentChunkCharCount += stringCharCount
            } else {
                chunks.append(currentChunk)
                currentChunk = [string]
                currentChunkCharCount = stringCharCount
            }
        }

        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }

        return chunks
    }

    func toggleGenreSelection(genre: String) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll(where: { $0 == genre })
        } else {
            selectedGenres.append(genre)
        }
    }

    func toggleAuthorsSelection(author: String) {
        if selectedAuthors.contains(author) {
            selectedAuthors.removeAll(where: { $0 == author })
        } else {
            selectedAuthors.append(author)
        }
    }
}
