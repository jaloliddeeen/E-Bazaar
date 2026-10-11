//
//  ProductDetailsView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 04/09/2026.
//

import Foundation
import SwiftUI

struct ProductDetailsView: View {
    let product: Product
    
    @EnvironmentObject private var cart: CartStore
    @EnvironmentObject private var wishlist: WishlistStore
    
    @State private var selectedColor = "Grey"
    @State private var selectedSize = "M"
    @State private var quantity = 1
    @State private var addedToCart = false
    
    private let colors = ["Grey", "Black", "Green"]
    private let sizes = ["S", "M", "L", "XL", "XXL", "XXXL"]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                imageGallery
                productSummary
                options
                productInformation
                sellerInformation
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Product")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                FavoriteButton(product: product)
                    .accessibilityLabel(wishlist.contains(product) ? "Remove from wishlist" : "Add to wishlist")
                
                ShareLink(item: productShareText) {
                    Image(systemName: "square.and.arrow.up")
                }
                .foregroundColor(.black)
                .accessibilityLabel("Share item")
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            addToCartBar
        }
    }
    
    
    private var imageGallery: some View {
        TabView {
            Image(product.imageName)
        }
        .tabViewStyle(.page)
        .frame(height: 400)
        .background(Color(.secondarySystemBackground))
        .accessibilityLabel("Product image")
    }
    
    
    private func productImage(_ imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(24)
            .accessibilityLabel(product.name)
    }
    
    
    private var productSummary: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text("$\(product.currentPrice, format: .number.precision(.fractionLength(2)))")
                    .font(.title.bold())
                
                Text("$\(product.originalPrice, format: .number.precision(.fractionLength(2)))")
                    .foregroundStyle(.secondary)
                    .strikethrough()
                
                if product.isTop {
                    Text("TOP")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.orange, in: Capsule())
                }
                
                Text(product.discount)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.red, in: Capsule())
            }
            
            Text(product.name)
                .font(.title3.weight(.semibold))
            
            Label {
                Text("\(product.rating, format: .number.precision(.fractionLength(1)))   •   \(product.purchaseCount) ratings")
                    .foregroundStyle(.secondary)
            } icon: {
                Image(systemName: "star.fill").foregroundStyle(.yellow)
            }
        }
        .padding(.horizontal, 20)
    }
    
    
    private var options: some View {
        VStack(alignment: .leading, spacing: 20) {
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Color").font(.headline)
                Picker("Color", selection: $selectedColor) {
                    ForEach(colors, id: \.self) { color in
                        Text(color).tag(color)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Size").font(.headline)
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 46), spacing: 10)], spacing: 10) {
                    ForEach(sizes, id: \.self) { size in
                        Button(size) { selectedSize = size }
                            .font(.subheadline.weight(.semibold))
                            .frame(minWidth: 46, minHeight: 44)
                            .background(
                                selectedSize == size ? Color.navyBlue : Color.clear,
                                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                            )
                            .foregroundStyle(selectedSize == size ? .white : Color.primary)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.navyBlue.opacity(selectedSize == size ? 0 : 0.3))
                            }
                            .accessibilityLabel("Size \(size)")
                            .accessibilityAddTraits(selectedSize == size ? .isSelected : [])
                    }
                }
            }
            
            Divider()
            
            Stepper(value: $quantity, in: 1...10) {
                Text("Quantity: \(quantity)").font(.headline)
            }
        }
        .padding(.horizontal, 20)
    }
    
    
    private var productInformation: some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            
            DisclosureGroup("About this product") {
                Text("A versatile, comfortable product designed for everyday use. Choose your preferred color and size before adding it to the cart.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
            }
            .padding(.vertical, 16)

            Divider()
            
            DisclosureGroup("Specifications") {
                LabeledContent("Material", value: "Premium blend")
                LabeledContent("Delivery", value: "14 days")
            }
            .padding(.vertical, 16)
            Divider()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
        .padding(.horizontal, 20)
    }
    
    
    private var sellerInformation: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sold by").font(.headline)
            
            NavigationLink {
                Text("Seller profile")
                    .navigationTitle("Seller")
            } label: {
                Label("Super gadgets", systemImage: "storefront")
                   .foregroundStyle(.primary)
                   .frame(maxWidth: .infinity, alignment: .leading)
                   .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.horizontal, 20)
    }
    
    
    private var addToCartBar: some View {
        let isInCart = cart.contains(product)
        
        return Button {
            cart.toggle(product, quantity: quantity)
        } label: {
            Label(
                isInCart ? "Remove from cart" : "Add to cart",
                systemImage: isInCart ? "cart.badge.minus" : "plus"
            )
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(isInCart ? .red : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isInCart ? Color(.systemBackground) : Color.navyBlue)
            .clipShape(Capsule())
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(isInCart ? Color.red : Color.clear, lineWidth: 1.5)
            )
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bar)
    }
    
    
    private var productShareText: String {
        "Check out \(product.name) for $\(String(format: "%.2f", product.currentPrice))."
    }
}


#Preview {
    NavigationStack {
        ProductDetailsView(
            product: Product(
                name: "Men’s Water Resistant Windbreaker with Stand Collar",
                imageName: "product5",
                currentPrice: 48.99,
                originalPrice: 58.99,
                rating: 4.6,
                purchaseCount: 1240,
                discount: "-12%",
                isTop: true
            )
        )
    }
    .environmentObject(CartStore())
    .environmentObject(WishlistStore())
}
