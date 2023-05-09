//
//  ChunkedArray.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 04.05.2023.
//

import Foundation

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
