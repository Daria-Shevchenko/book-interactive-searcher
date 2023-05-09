//
//  TabBarView.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import Foundation
import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var viewModel: AppViewModel

    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            RecommendationsView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Bookshelf")
                }
                .tag(0)
            RecentSearchView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Recent Search")
                }
                .tag(1)

            ScannerView(onTap: { selectedTab = 3 })
                .tabItem {
                    Image(systemName: "video")
                    Text("Scanner")
                }
                .tag(2)

            ARViewContainer()
                .ignoresSafeArea(.all)
                .tabItem {
                    Image(systemName: "cube.fill")
                    Text("AR")
                }
                .tag(3)
        }
        .accentColor(.white)
        .onChange(of: selectedTab) { newValue in
            if newValue == 2 {
                viewModel.isVisable = true
            }
        }
    }
}
