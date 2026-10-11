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
    
    @State private var activeOrders: [CustomerOrder] = [
            CustomerOrder(
                id: "6352",
                status: .initialPreparation,
                statusDescription: "The seller has confirmed your order – he is already collecting the parcel",
                estimatedDelivery: "Until October 23",
                deliveryAddress: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900",
                tab: .active,
                items: [
                    OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-48", imageName: "mug.fill")
                ],
                discount: 0.56,
                deliveryCost: 16.78
            )
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
                        OrderListView()
                    } label: {
                        Label("Orders", systemImage: "cube.box")
                    }
                    
                    NavigationLink {
                        ChatListView()
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
            NavigationLink {
                OrderDetailView(order: order)
            } label: {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Order ID - \(order.id)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.primary)
                        
                        Text(order.status.rawValue)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(order.status.tintColor)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(order.status.tintColor.opacity(0.15), in: Capsule())
                    }
                    
                    Spacer()
                    
                    if let firstItem = order.items.first {
                        Image(systemName: firstItem.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .padding(10)
                            .foregroundStyle(Color.accentColor)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .padding(.vertical, 4)
            }
        }
            
    }
    
}


struct Order: Identifiable {
    let id: String
    let status: String
    let imageName: String
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
