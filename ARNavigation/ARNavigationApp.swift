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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
