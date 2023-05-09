//
//  CenterProgressView.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 22.04.2023.
//

import Foundation
import SwiftUI

struct CenterProgressView: View {
    // MARK: - Body

    var body: some View {
        Spacer()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        Spacer()
    }
}
