//
//  ARNavigationApp.swift
//  ARNavigation
//
//  Created by ck on 2023/3/8.
//

import SwiftUI

@main
struct ARNavigationApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnboardingView(isOnboarding: $isFirstLaunch)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
