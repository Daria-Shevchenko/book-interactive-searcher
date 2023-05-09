//
//  PreferencePageTitle.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 25.04.2023.
//

import Foundation
import SwiftUI

struct PreferencePageTitle: View {
    // MARK: - Properties

    var text: String

    // MARK: - Body

    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal, 10)
    }
}
