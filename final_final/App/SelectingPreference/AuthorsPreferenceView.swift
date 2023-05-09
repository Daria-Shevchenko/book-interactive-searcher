//
//  AuthorsPreferenceView.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 02.05.2023.
//

import CSV
import Foundation
import SwiftUI

struct AuthorsPreferenceView: View {
    // MARK: - Properties

    @EnvironmentObject var viewModel: SelectingPreferenceViewModel
    @EnvironmentObject var recommendationsViewModel: RecommendationsViewModel

    @AppStorage("preferenceAuthor") var isPreferenceSelectingAuthorActive: Bool = true

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading, spacing: 10) {
                PreferencePageTitle(text: viewModel.titleAuthor)
                if viewModel.authors.count > 0 {
                    PreferenceOptionView(options: viewModel.authorsToDisplay,
                                         selectedOptions: viewModel.selectedAuthors,
                                         toggleSelection: viewModel.toggleAuthorsSelection)
                    PreferenceContinueButton(onTap: {
                        isPreferenceSelectingAuthorActive = false
                        recommendationsViewModel.selectedAuthors = viewModel.selectedAuthors
                    })
                } else {
                    CenterProgressView()
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}
