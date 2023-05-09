//
//  PreferenceContinueButton.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 25.04.2023.
//

import Foundation
import SwiftUI

struct PreferenceContinueButton: View {
    // MARK: - Properties

    var onTap: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text("Continue")
                .font(.system(size: 18))
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .padding(.horizontal, 60)
                .padding(.vertical, 10)
                .background(Color.black)
                .cornerRadius(30)
        }
        .padding([.bottom, .leading], 20)
    }
}
