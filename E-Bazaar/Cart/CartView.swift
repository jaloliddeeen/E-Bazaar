//
//  CartView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 07/09/2026.
//

import SwiftUI

enum CartRoute: Hashable {
    case checkout(total: Double)
}

struct CartView: View {
    @EnvironmentObject private var cart: CartStore
    @EnvironmentObject var router: AppRouter
    @State private var isShowingCheckout = false
    
    var body: some View {
        NavigationStack {
            Group {
                if cart.lineItems.isEmpty {
                    ContentUnavailableView(
                        "Your cart is empty",
                        systemImage: "cart",
                        description: Text("Your items will show up here")
                    )
                } else {
                    populatedCart
                }
            }
            .navigationTitle("Your cart")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var populatedCart: some View {
        List {
            Section {
                ForEach(cart.lineItems, id: \.product.id) { item in
                    CartRowView(product: item.product) { cart.remove(item.product) }
                }
            }
            
            Section {
                summaryRow("Products (\(cart.selectedItemCount))", value: cart.subTotal)
                summaryRow("Discount", value: -cart.discount)
                summaryRow("Delivery cost", value: cart.deliveryCost)
                summaryRow("Overall", value: cart.overall, isBold: true)
            }
            .listRowBackground(Color(.secondarySystemBackground))
        }
        .listStyle(.insetGrouped)
        .safeAreaInset(edge: .bottom, spacing: 0) { checkoutBar }
        .navigationDestination(isPresented: $isShowingCheckout) {
            CheckoutView(total: cart.overall)
        }
    }
    
    
    
    private func summaryRow(_ title: String, value: Double, isBold: Bool = false) -> some View {
            LabeledContent {
                Text(value, format: .currency(code: "USD"))
            } label: {
                Text(title)
            }
            .fontWeight(isBold ? .bold : .regular)
            .foregroundStyle(isBold ? .primary : .secondary)
        }
    
    
    
    private var checkoutBar: some View {
        HStack(spacing: 16) {
            Button { isShowingCheckout = true } label: {
                Text("Go to checkout")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(cart.selectedLineItems.isEmpty ? Color(.systemGray4) : Color.navyBlue)
                    .clipShape(Capsule())
            }
            .disabled(cart.selectedLineItems.isEmpty)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bar)
    }
}





struct SelectionCheckbox: View {
    @Binding var isOn: Bool
    var accessibilityLabel: String
    
    var body: some View {
        Button { isOn.toggle() } label: {
            Color.clear
                .frame(width: 24, height: 44)
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(isOn ? Color.navyBlue : Color.clear)
                        .frame(width: 24, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(isOn ? Color.clear : Color(.systemGray3), lineWidth: 1.5)
                        )
                )
            
                .overlay{
                    if isOn {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isOn ? [.isSelected] : [] )
    }
}


struct QuantityStepper: View {
    @Binding var quantity: Int
    var range: ClosedRange<Int> = 1...10
    
    var body: some View {
        HStack(spacing: 12) {
            stepButton(systemName: "minus", isEnabled: quantity > range.lowerBound) {
                quantity -= 1
            }
            Text("\(quantity)")
                .font(.subheadline.weight(.semibold))
                .frame(minWidth: 20)
            stepButton(systemName: "plus", isEnabled: quantity < range.upperBound) {
                quantity += 1
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Quantity")
        .accessibilityValue("\(quantity)")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment where quantity < range.upperBound: quantity += 1
            case .decrement where quantity > range.lowerBound: quantity -= 1
            default: break
            }
        }
    }
    
    
    private func stepButton(systemName: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isEnabled ? .navyBlue : Color(.systemGray3))
                .frame(width: 32, height: 32)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}


final class WishlistStore: ObservableObject {
    @Published private(set) var products: [UUID: Product] = [:]
    
    var items: [Product] {
        Array(products.values)
    }
    
    func contains(_ product: Product) -> Bool {
        products[product.id] != nil
    }
    
    func add(_ product: Product) {
        products[product.id] = product
    }

    func remove(_ product: Product) {
        products[product.id] = nil
    }

    func toggle(_ product: Product) {
        if contains(product) {
            remove(product)
        } else {
            add(product)
        }
    }    
}


#Preview("Populated") {
    let cart = CartStore()
    let wishlist = WishlistStore()
    let sampleProducts = [
        Product(name: "Smart watch BIG T800 Pro Max", imageName: "product2", currentPrice: 26.99, originalPrice: 27.55, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", imageName: "product2", currentPrice: 10.99, originalPrice: 10.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: false),
        Product(name: "Pled EMA AD-0881 100% akril, 150*200", imageName: "product2", currentPrice: 22.99, originalPrice: 22.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: false)
    ]
    sampleProducts.forEach { cart.add($0, quantity: 1) }

    return CartView()
        .environmentObject(cart)
        .environmentObject(wishlist)
}

#Preview("Empty") {
    CartView()
        .environmentObject(CartStore())
        .environmentObject(WishlistStore())
}
