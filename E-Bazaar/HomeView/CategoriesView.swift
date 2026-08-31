//
//  CategoriesView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 06/09/2026.
//

import SwiftUI

struct ShopCategory: Identifiable, Hashable {
    let id: String
    let name: String
    let emoji: String
}

struct CategoriesView: View {
    @State private var searchText = ""
    
    private let categories = [
        ShopCategory(id: "books", name: "Books", emoji: "📚"),
        ShopCategory(id: "home", name: "Home & Kitchen", emoji: "🏠"),
        ShopCategory(id: "toys", name: "Kids’ Toys", emoji: "🧸"),
        ShopCategory(id: "clothes", name: "Clothes", emoji: "👕"),
        ShopCategory(id: "gadgets", name: "Gadgets", emoji: "📱"),
        ShopCategory(id: "shoes", name: "Shoes", emoji: "👟"),
        ShopCategory(id: "beauty", name: "Beauty", emoji: "💄"),
        ShopCategory(id: "sports", name: "Sports", emoji: "⚽️"),
        ShopCategory(id: "baby", name: "For Babies", emoji: "👶"),
        ShopCategory(id: "pets", name: "Pet Supplies", emoji: "🐾"),
        ShopCategory(id: "games", name: "Video Games", emoji: "🎮"),
        ShopCategory(id: "tools", name: "Tools", emoji: "🛠️"),
        ShopCategory(id: "health", name: "Healthcare", emoji: "🩺"),
        ShopCategory(id: "auto", name: "For Auto", emoji: "🚗"),
        ShopCategory(id: "fishing", name: "Fishing", emoji: "🎣"),
        ShopCategory(id: "food", name: "Food", emoji: "🥬"),
        ShopCategory(id: "hygiene", name: "Hygiene", emoji: "🧴"),
        ShopCategory(id: "office", name: "For Office", emoji: "✏️"),
        ShopCategory(id: "garden", name: "Garden", emoji: "🪴")
    ]
    
    private var filteredCategories: [ShopCategory] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
 
    var body: some View {
        ScrollView {
            LazyVGrid (
                columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 4),
                spacing: 22
            ) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink {
                        CategoryProductView(category: category)
                    } label: {
                        categoryTile(category)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(category.name)
                }
            }
            .padding(16)
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search categories")
    }
    
    private func categoryTile(_ category: ShopCategory) -> some View {
        VStack(spacing: 8) {
            Text(category.emoji)
                .font(.system(size: 34))
                .frame(maxWidth: .infinity)
                .frame(height: 76)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
            
            Text(category.name)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(maxWidth: .infinity, minHeight: 36, alignment: .top)
        }
        .contentShape(Rectangle())
    }
    
}



struct CategoryProductView: View {
    let category: ShopCategory
    
    @State private var visibleProductCount = 4

    private var products: [Product] {
        CategorySampleData.products(for: category)
    }
    
    private var visibleProducts: ArraySlice<Product> {
        products.prefix(visibleProductCount)
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Found \(products.count * 16) products")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 16)

                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible())],
                    spacing: 28
                ) {
                    ForEach(visibleProducts) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(.horizontal, 16)
                
                
                if visibleProductCount < products.count {
                    Button {
                        visibleProductCount = min(visibleProductCount + 8, products.count)
                    } label: {
                        Label("Load 8 more", systemImage: "arrow.clockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.navyBlue)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    
                }
            }
            .padding(.vertical, 16)
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}



private enum CategorySampleData {
    private static let homeNames = [
        "Stainless steel whistling kettle",
        "Soft cotton throw blanket",
        "Bamboo kitchen organizer",
        "Ceramic dinnerware set"
    ]
    
    
    private static let allProducts: [Product] = {
        return (0..<12).map { index in
            Product(
                name: homeNames[index % homeNames.count],
                imageName: "product\((index % 4) + 1)",
                currentPrice: [10.99, 22.99, 18.49, 34.99][index % 4],
                originalPrice: [15.99, 29.99, 24.99, 44.99][index % 4],
                rating: 4.6,
                purchaseCount: 25,
                discount: "-12%",
                isTop: index.isMultiple(of: 3)
            )
        }
    }()
    
    static func products(for category: ShopCategory) -> [Product] {
        allProducts
    }
}


#Preview {
    NavigationStack {
        CategoriesView()
    }
    .environmentObject(CartStore())
}
