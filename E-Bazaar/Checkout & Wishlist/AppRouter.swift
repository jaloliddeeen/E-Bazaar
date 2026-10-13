//
//  AppRouter.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 12/09/2026.
//

import SwiftUI

final class AppRouter: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var selectedCategoryName: String? = nil
    @Published var cartPath = NavigationPath()
    @Published var isShowingCheckout = false
}
