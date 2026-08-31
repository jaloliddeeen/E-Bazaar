//
//  CheckoutView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 08/09/2026.
//

import SwiftUI

struct CheckoutView: View {
    let total: Double
    
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var cart: CartStore
    
    @State private var navigateToAddAddress = false
    @State private var navigateToAddCard = false
    
    @State private var deliveryAddress: DeliveryAddress? = nil
    @State private var paymentCard: PaymentCard? = nil

    @State private var checkoutStatus: CheckoutStatus? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                sectionCard(title: "Delivery address") {
                    if let address = deliveryAddress {
                        HStack(alignment: .center, spacing: 12) {
                            Text(address.formattedString)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .lineLimit(3)
                            
                            Spacer()
                            
                            Button("Change") {
                                navigateToAddAddress = true
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground), in: Capsule())
                        }
                    } else {
                        Button {
                            navigateToAddAddress = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add delivery address")
                                Spacer()
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.accentColor)
                            .frame(height: 36)
                        }
                        .buttonStyle(.plain)
                    }
                }
                 
                sectionCard(title: "Payment method") {
                    if let card = paymentCard {
                        HStack(alignment: .center, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("•••• •••• •••• \(card.lastFourDigits)")
                                    .font(.subheadline.weight(.medium))
                                    .foregroundColor(.primary)
                                
                                Text("Expires \(card.expirationDate)")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button("Change") {
                                navigateToAddCard = true
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground), in: Capsule())
                        }
                    } else {
                        Button {
                            navigateToAddCard = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add a card")
                                Spacer()
                            }
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.accentColor)
                            .frame(height: 36)
                        }
                        .buttonStyle(.plain)
                    }
                }
                 
                totalRow
            }
            .padding(20)
        }
        .navigationTitle("Checkout")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) { confirmButton }
        .navigationDestination(isPresented: $navigateToAddAddress) {
            AddAddressSheet { savedAddress in
                deliveryAddress = savedAddress
            }
        }
        .navigationDestination(isPresented: $navigateToAddCard) {
            AddCardView { savedCard in
                paymentCard = savedCard
            }
        }
        .overlay {
            if let status = checkoutStatus {
                CheckoutStatusOverlay(
                    status: status,
                    onClose: {
                        checkoutStatus = nil
                    },
                    onPrimaryAction: {
                        checkoutStatus = nil
                        navigateToHome()
                    },
                    onSecondaryAction: {
                        checkoutStatus = nil
                        navigateToOrders()
                    }
                )
            }
        }
    }
    
    
    private func navigateToHome() {
        cart.clearCart()
        router.cartPath = NavigationPath()
        router.isShowingCheckout = false
        router.selectedTab = 0
    }
    
    private func navigateToOrders() {
        cart.clearCart()
        router.cartPath = NavigationPath()
        router.selectedTab = 4
    }
    
     
    private func sectionCard(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding(16)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
     
    private func placeholderButton(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: "plus")
                Text(label)
                Spacer()
            }
            .font(.subheadline.weight(.medium))
            .foregroundColor(.accentColor)
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }
     
    private var totalRow: some View {
        HStack {
            Text("Total to be paid:").font(.headline)
            Spacer()
            Text(total, format: .currency(code: "USD")).font(.headline)
        }
        .padding(.horizontal, 4)
    }
     
    private var confirmButton: some View {
        Button {
            processPaymentStimulation()
        } label: {
            Text("Confirm the order")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(deliveryAddress != nil && paymentCard != nil ? Color.accentColor : Color(.systemGray4))
                .clipShape(Capsule())
        }
        .disabled(deliveryAddress == nil || paymentCard == nil)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bar)
    }
    
    
    private func processPaymentStimulation() {
        checkoutStatus = .awaiting
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            checkoutStatus = .success(estimatedDelivery: "Nov 23, 2027")
        }
    }
}

#Preview {
    NavigationStack {
        CheckoutView(total: 334.21)
            .environmentObject(AppRouter())
    }
}
