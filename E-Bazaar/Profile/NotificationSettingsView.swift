//
//  NotificationSettingsView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 15/09/2026.
//

import SwiftUI

struct NotificationSettingsView: View {
    @AppStorage("notif_email") private var emailNotifications = true
    @AppStorage("notif_hot_products") private var hotProducts = true
    @AppStorage("notif_twenty_percent") private var twentyPercentSale = false
    @AppStorage("notif_fifty_percent") private var fiftyPercentDiscounts = false
    @AppStorage("notif_black_friday") private var blackFridaydiscounts = true

    
    var body: some View {
        List {
            Section {
                Toggle("Email Notifications", isOn: $emailNotifications)
            } footer: {
                Text("Receive order summaries and delivery updates via your registered email address.")
            }
            
            Section("Promotions & Offers") {
                Toggle("Hot products", isOn: $hotProducts)
                Toggle("20% sale products", isOn: $twentyPercentSale)
                Toggle("50% sale products", isOn: $fiftyPercentDiscounts)
                Toggle("Black Friday sale", isOn: $blackFridaydiscounts)
            }
            .disabled(!emailNotifications)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Notification settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
