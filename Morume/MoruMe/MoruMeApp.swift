//
//  MoruMeApp.swift
//  Morume
//
//  Created by 青原光 on 2025/05/15.
//

import FirebaseAuth
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MoruMeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var toastManager = ToastManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(toastManager)
        }
    }
}
