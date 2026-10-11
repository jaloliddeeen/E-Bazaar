//
//  E_BazaarApp.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 31/08/2026.
//

import SwiftUI

@main
struct E_BazaarApp: App {
    @StateObject private var router = AppRouter()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .environmentObject(router)
        }
    }
}
