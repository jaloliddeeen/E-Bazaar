//
//  HomeTabBar.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 03/09/2026.
//

import SwiftUI

struct HomeTabBar: View {
    let products: [Product]
    
    var body: some View {
        HStack(spacing: 16) {
            Image("app_logo")
                .resizable()
                .scaledToFit()
                .frame(height: 32)
                .accessibilityLabel("E-Bazaar")
            
            Spacer()
            
            NavigationLink {
                SearchExperienceView(products: products)
            } label : {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.blue)
                    .frame(width: 44, height: 44)
            }
            .accessibilityLabel("search products")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}

#Preview {
    NavigationStack {
        HomeTabBar(products: [] )
    }
}
