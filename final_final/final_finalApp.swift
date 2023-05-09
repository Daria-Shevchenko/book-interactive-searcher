//
//  final_finalApp.swift
//  final_final
//
//  Created by Daria Shevchenko on 01.05.2023.
//

import SwiftUI

// @main
// struct final_finalApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
// }

@main
struct final_finalApp: App {
    @StateObject private var vm = AppViewModel()
    @StateObject var recommendationViewModel = RecommendationsViewModel()
    @StateObject var preferenceViewModel = SelectingPreferenceViewModel()
    @StateObject var arViewModel = ARViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .environmentObject(recommendationViewModel)
                .environmentObject(preferenceViewModel)
                .environmentObject(arViewModel)
                .task {
                    await vm.requestDataScannerAccessStatus()
                }
        }
    }
}
