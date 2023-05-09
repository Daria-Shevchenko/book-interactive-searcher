//
//  LikeButton.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 25.04.2023.
//

import Foundation
import SwiftUI

struct LikeButton: View {
    @State var isLiked: Bool

    var action: (Bool) -> Void

    // MARK: - Body

    var body: some View {
        VStack {
            Button(action: {
                isLiked.toggle()
                action(isLiked)
            }) {
                HStack {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.subheadline)
                        .foregroundColor(isLiked ? .black : .gray)

                    Text("Add to favorites")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
