//
//  GenresPreferenceView.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import CSV
import Foundation
import SwiftUI

struct GenrePreferenceView: View {
    // MARK: - Properties

    @EnvironmentObject var viewModel: SelectingPreferenceViewModel
    @EnvironmentObject var recommendationsViewModel: RecommendationsViewModel

    @AppStorage("preference") var isPreferenceSelectingActive: Bool = true

    // MARK: - Body

    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading, spacing: 10) {
                PreferencePageTitle(text: viewModel.titleGenre)
                if viewModel.genres.count > 0 {
                    PreferenceOptionView(options: viewModel.genresToDisplay,
                                         selectedOptions: viewModel.selectedGenres,
                                         toggleSelection: viewModel.toggleGenreSelection)
                    PreferenceContinueButton(onTap: {
                        isPreferenceSelectingActive = false
                        recommendationsViewModel.selectedGenres = viewModel.selectedGenres
                        recommendationsViewModel.getFilterBooks()
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
