//
//  DivingNewsApp.swift
//  DivingNews
//
//  Created by 中道徹 on 2023/04/27.
//

import SwiftUI

@main
struct DivingNewsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
