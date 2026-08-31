//
//  SplashScreen.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 31/08/2026.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                Text("E-Bazaar")
                    .font(.system(size: 44, weight: .heavy, design: .default))
                    .foregroundColor(Color(red: 0.08, green: 0.18, blue: 0.38))
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeIn(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
