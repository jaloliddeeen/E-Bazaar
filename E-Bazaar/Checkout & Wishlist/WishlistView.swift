//
//  WishlistView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 13/09/2026.
//

import SwiftUI

struct WishlistView: View {
    @EnvironmentObject var wishlist: WishlistStore
    @EnvironmentObject var cart: CartStore
    
    private var columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        Group {
            if wishlist.items.isEmpty {
                ContentUnavailableView(
                    "Your wishlist is empty",
                    systemImage: "heart",
                    description: Text("Items you favourite will appear here")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(wishlist.items) { product in
                            WishlistProductCard(product: product)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Wishlist")
        .navigationBarTitleDisplayMode(.large)
    }
}


struct WishlistProductCard: View {
    let product: Product
    @EnvironmentObject var wishlist: WishlistStore
    @EnvironmentObject var cart: CartStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Color(.secondarySystemBackground)
                    .frame(height: 160)
                    .overlay(
                        Image(product.imageName)
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                    )
                
                Button {
                    wishlist.toggle(product)
                } label: {
                    Image(systemName: wishlist.contains(product) ? "heart.fill" : "heart")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(wishlist.contains(product) ? .red : .black)
                        .padding(8)
                        .background(.white, in: Circle())
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(.plain)
                .padding(10)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.currentPrice, format: .currency(code: "USD"))
                    .font(.headline.weight(.bold))
                
                Text(product.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text(String(format: "%.1f", product.rating))
                        .font(.caption.weight(.medium))
                    Text("• \(product.purchaseCount) bought")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 4)
            
            Button {
                cart.add(product)
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add to cart")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.clear)
                .overlay(
                    Capsule()
                        .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
    }
}


#Preview {
    let wishlist = WishlistStore()
    let cart = CartStore()
    let sample = Product(name: "Pled EMA AD-0881 100% akril, 150*200", imageName: "product2", currentPrice: 22.99, originalPrice: 22.99, rating: 4.6, purchaseCount: 25, discount: "-12%", isTop: false)
    wishlist.add(sample)
    
    return NavigationStack {
        WishlistView()
            .environmentObject(wishlist)
            .environmentObject(cart)
    }
}
