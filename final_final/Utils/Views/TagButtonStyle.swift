//
//  TagButtonStyle.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 23.04.2023.
//

import Foundation
import SwiftUI

public struct TagButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}
