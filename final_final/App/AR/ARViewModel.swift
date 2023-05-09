//
//  ARViewModel.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 03.05.2023.
//

import CSV
import Foundation
import SwiftUI

final class ARViewModel: ObservableObject {
    @Published var booksScanned = [Book]()
    @Published var scannedText = ""
    @Published var scannedTextArray: [String] = []

    let csvUrl = "https://firebasestorage.googleapis.com/v0/b/bookshelf-d0a42.appspot.com/o/full-books-new.csv?alt=media&token=1f3c41b3-e17b-439a-a501-8fbf8c9f57ab"

    init() {}

    func updateInfo() {
        getBook()
    }

    private func getBook() {
        FirebaseStorageManager.downloadFile(from: csvUrl) { data, error in
            if let data = data {
                self.processBook(data: data)
            } else if let error = error {
                print("Error downloading file: \(error.localizedDescription)")
            }
        }
    }

    private func processBook(data: Data) {
        if let csvString = String(data: data, encoding: .utf8) {
            do {
                let csv = try CSVReader(string: csvString, hasHeaderRow: true)
                while let row = csv.next() {
                    if searchByScannedText(data: scannedText, title: row[1]) {
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
                                           price: "\(price)$",
                                           desc: desc,
                                           genresList: parsedGenresList)
                        booksScanned.append(newBook)
                        break
                    }
                }
            } catch {
                print("Error reading CSV file: \(error)")
            }
        } else {
            print("Error parsing CSV")
        }
    }

    private func searchByScannedText(data: String, title: String) -> Bool {
        let words = data.components(separatedBy: .whitespacesAndNewlines)
        let lowercasedWords = words.map { $0.lowercased() }
        let titleData = title.components(separatedBy: .whitespaces).map { $0.lowercased() }
        if lowercasedWords.contains(where: { titleData.contains($0) }) {
            return true
        } else {
            return false
        }
    }

    private func getBookGenres(string: String) -> [String] {
        let cleanedString = string.replacingOccurrences(of: "[\\[\\]']", with: "", options: .regularExpression)
        return cleanedString.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }
}
