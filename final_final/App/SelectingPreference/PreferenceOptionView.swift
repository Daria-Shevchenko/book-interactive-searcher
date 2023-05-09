//
//  PreferenceOptionView.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 05.05.2023.
//

import Foundation
import SwiftUI

struct PreferenceOptionView: View {
    // MARK: - Properties

    let options: [[String]]
    let selectedOptions: [String]
    let toggleSelection: (String) -> Void

    // MARK: - Body

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                ForEach(options, id: \.self) { optionRow in
                    HStack(spacing: 10) {
                        ForEach(optionRow, id: \.self) { option in
                            Button(action: {
                                toggleSelection(option)
                            }) {
                                Text(option)
                                    .font(.system(size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(selectedOptions.contains(option) ? Color.black : Color.gray.opacity(0.7))
                                    .cornerRadius(20)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .buttonStyle(TagButtonStyle())
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, 10)
        }
    }
}
