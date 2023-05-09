//
//  FirebaseStorageManager.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 03.05.2023.
//

import FirebaseStorage
import Foundation

final class FirebaseStorageManager {
    private static let storage = Storage.storage()

    static func downloadFile(from url: String, completion: @escaping (Data?, Error?) -> Void) {
        let storageRef = storage.reference(forURL: url)

        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            completion(data, error)
        }
    }
}
