//
//  LabelledDivider.swift
//  final_final
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import Foundation
import SwiftUI

struct LabelledDivider: View {
    let label: String
    let horizontalPadding: CGFloat = 10
    let color: Color = .gray

    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
                .font(.caption)
                .lineLimit(1)
            line
        }
        .padding(.vertical, 5)
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}
