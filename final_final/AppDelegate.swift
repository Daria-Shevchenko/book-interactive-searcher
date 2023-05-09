//
//  AppDelegate.swift
//  Bookshelf
//
//  Created by Daria Shevchenko on 03.05.2023.
//

import Firebase
import Foundation
import SwiftUI
import Swinject

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}
