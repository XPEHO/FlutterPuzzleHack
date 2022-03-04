//
//  RunnerApp.swift
//  puzzlewatch WatchKit Extension
//
//  Created by Piotr FLEURY on 28/02/2022.
//

import SwiftUI

@main
struct RunnerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
