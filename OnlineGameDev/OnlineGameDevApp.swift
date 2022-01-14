//
//  OnlineGameDevApp.swift
//  OnlineGameDev
//
//  Created by David Kababyan on 02/07/2021.
//

import SwiftUI
import Firebase

@main
struct OnlineGameDevApp: App {
        
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
