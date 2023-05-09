//
//  ContentView.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import RealityKit
import SwiftUI

struct ContentView: View {
    @AppStorage("starting") var isOnbordingViewActive: Bool = true
    @AppStorage("preference") var isPreferenceSelectingActive: Bool = true
    @AppStorage("preferenceAuthor") var isPreferenceSelectingAuthorActive: Bool = true

    var body: some View {
        ZStack {
            if isOnbordingViewActive {
                StartView()
            } else {
                if isPreferenceSelectingActive {
                    if isPreferenceSelectingAuthorActive {
                        AuthorsPreferenceView()
                    } else {
                        GenrePreferenceView()
                    }
                } else {
                    TabBarView()
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: [isOnbordingViewActive, isPreferenceSelectingActive])
        .transition(.opacity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
