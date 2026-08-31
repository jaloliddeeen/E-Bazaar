//
//  CartRowView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 07/09/2026.
//

import SwiftUI

struct CartRowView: View {
    let product: Product
    @EnvironmentObject private var cart: CartStore
    @EnvironmentObject private var wishlist: WishlistStore
    var onRemove: () -> Void
    
    private var variant: (color: String, size: String) {
        cart.variants[product.id] ?? ("Black", "36-37")
    }
    
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            SelectionCheckbox(
                isOn: cart.selectionBinding(for: product),
                accessibilityLabel: "Include \(product.name) in order"
            )
            .padding(.top, 8)
            
            Image(product.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    priceLabel
                    
                    Spacer()
                    
                    favoriteButton
                }
                
                Text(product.name)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Text("Color \(variant.color)  •  Size: \(variant.size)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                QuantityStepper(quantity: cart.quantityBinding(for: product))
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive, action: onRemove) {
                Label("Remove", systemImage: "trash")
            }
            .tint(.red)
        }
    }
    
    
    private var priceLabel : some View {
        HStack(spacing: 6) {
            Text(product.currentPrice, format: .currency(code: "USD"))
                .font(.headline.bold())
            
            if product.originalPrice > product.currentPrice {
                Text(product.originalPrice, format: .currency(code: "USD"))
                    .font(.body.bold())
                    .foregroundStyle(.secondary)
                    .strikethrough()
            }
        }
    }
    
    
    private var favoriteButton: some View {
        Button { wishlist.toggle(product) } label: {
            Image(systemName: wishlist.contains(product) ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundColor(wishlist.contains(product) ? .red : .black)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(wishlist.contains(product) ? "Remove from wishlist" : "Add to wishlist")
    }
}



#Preview {
    let cart = CartStore()
    let wishlist = WishlistStore()
    let sample = Product(
        name: "Teapot Kukmara stainless steel, with a Whistle, 3 liters",
        imageName: "product2",
        currentPrice: 10.99,
        originalPrice: 10.99,
        rating: 4.8,
        purchaseCount: 25,
        discount: "-12%",
        isTop: false
    )
    cart.add(sample, quantity: 1, color: "Black", size: "36-40")

    return List {
        CartRowView(product: sample) { }
    }
    .listStyle(.plain)
    .environmentObject(cart)
    .environmentObject(wishlist)
}
