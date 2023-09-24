//
//  TUIGroupApp.swift
//  TUIGroup
//
//  Created by Oscar Rodriguez Garrucho on 21/9/23
//  Linkedin: https://www.linkedin.com/in/oscar-garrucho/
//  Copyright © 2023 Oscar Rodriguez Garrucho. All rights reserved.
//

import SwiftUI

@main
struct TUIGroupApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    ContentView()
                }
            } else {
                // Fallback on earlier versions
                NavigationView {
                    ContentView()
                }
            }
        }
    }
}
