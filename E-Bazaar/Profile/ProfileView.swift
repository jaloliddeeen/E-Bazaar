//
//  ProfileView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 13/09/2026.
//

import SwiftUI

struct ProfileView: View {
    @State private var unreadMessagesCount = 1
    @State private var savedAddressesCount = 2
    @State private var linkedCardsCount = 2
    @State private var activeOrders: [Order] = [
        Order(id: "6352", status: "Preparation", imageName: "product5")
    ]
    
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    profileHeaderView
                }
                .listRowBackground(Color(.secondarySystemGroupedBackground))
                
                if !activeOrders.isEmpty {
                    Section(header: Text("Active orders")) {
                        activeOrdersCarousel
                    }
                }
                
                Section {
                    NavigationLink {
                        OrdersListView()
                    } label: {
                        Label("Orders", systemImage: "cube.box")
                    }
                    
                    NavigationLink {
                        MessagesView()
                    } label: {
                        HStack {
                            Label("Messages", systemImage: "message")
                            
                            Spacer()
                            
                            if unreadMessagesCount > 0 {
                                Text("\(unreadMessagesCount)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.red, in: Capsule())
                            }
                        }
                    }
                    
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        Label("Notification settings", systemImage: "bell")
                    }
                }
                
                Section {
                    NavigationLink {
                        DeliveryAddressesView()
                    } label: {
                        HStack {
                            Label("Delivery adresses", systemImage: "map")
                            Spacer()
                            Text("\(savedAddressesCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    NavigationLink {
                        LinkedCardsView()
                    } label: {
                        HStack {
                            Label("Linked cards", systemImage: "creditcard")
                            Spacer()
                            Text("\(linkedCardsCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
        }
    }
    
    
    private var profileHeaderView: some View {
        NavigationLink {
            SettingsView()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Text("MJ")
                        .font(.title2.bold())
                        .foregroundStyle(Color.accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Micheal Jackson")
                        .font(.subheadline)
                    
                    Text("michaeljackson.gmail.com")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
    
    
    private var activeOrdersCarousel: some View {
        ForEach(activeOrders) { order in
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Order ID - \(order.id)")
                        .font(.subheadline.bold())
                    
                    Text(order.status)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.15), in: Capsule())
                }
                
                Spacer()
                
                Image(order.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.vertical, 4)
        }
    }
    
}


struct Order: Identifiable {
    let id: String
    let status: String
    let imageName: String
}


struct OrdersListView: View {
    var body: some View {
        Text("Orders View")
    }
}


struct MessagesView: View {
    var body: some View {
        Text("Messages View")
    }
}



struct NotificationSettingsView: View {
    var body: some View {
        Text("Orders View")
    }
}



struct DeliveryAddressesView: View {
    var body: some View {
        Text("Orders View")
    }
}


struct SettingsView: View {
    @State private var name: String = "Michael"
    @State private var surname: String = "Jackson"
    @State private var phoneNumber: String = "+48 938-231-211"
    @State private var email: String = "michaeljackson@gmail.com"
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                TextField("Surname", text: $surname)
            }
            
            Section {
                TextField("Phone number", text: $phoneNumber)
                    .keyboardType(.numberPad)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
            }
        }
        .navigationTitle("Profile settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    dismiss()
                }
                .fontWeight(.semibold)
            }
        }
    }
}



#Preview {
    ProfileView()
}
