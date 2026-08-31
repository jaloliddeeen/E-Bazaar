//
//  HomeView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 31/08/2026.
//

import SwiftUI

extension Color {
    static let navyBlue = Color(red: 0.11, green: 0.16, blue: 0.35)
    static let cardBackground = Color(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0)
}

struct ProductCategory: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
}

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let currentPrice: Double
    let originalPrice: Double
    let rating: Double
    let purchaseCount: Int
    let discount: String
    let isTop: Bool
}

struct HomeView: View {
    
    @Binding var selectedTab: Int
    
    let categories = [
        ProductCategory(name: "Books", emoji: "📚"),
        ProductCategory(name: "Home", emoji: "🏠"),
        ProductCategory(name: "Kids' Toys", emoji: "🧸"),
        ProductCategory(name: "Clothes", emoji: "👕"),
        ProductCategory(name: "Gadgets", emoji: "📱"),
        ProductCategory(name: "Shoes", emoji: "👟"),
        ProductCategory(name: "Beauty", emoji: "💄"),
        ProductCategory(name: "Sports", emoji: "⚽️")
    ]
    
    @State private var products = [
        Product(name: "ABS Home Theater Systems Remote Control...", imageName: "product1", currentPrice: 430.0, originalPrice: 489.0, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "Men’s Water Resistant Windbreaker with Stand Collar", imageName: "product5", currentPrice: 48.99, originalPrice: 58.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "Gaming Chair Ergonomic Office Seat...", imageName: "product3", currentPrice: 145.99, originalPrice: 189.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "Cross-country adidas Men's hoodie SUPER...", imageName: "product4", currentPrice: 92.30, originalPrice: 139.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "ABS Home Theater Systems Remote Control...", imageName: "product1", currentPrice: 430.0, originalPrice: 489.0, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: true),
        Product(name: "Children smart watch Smart, smart watch for...", imageName: "product2", currentPrice: 19.99, originalPrice: 27.55, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: false),
        Product(name: "Gaming Chair Ergonomic Office Seat...", imageName: "product3", currentPrice: 145.99, originalPrice: 189.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: false),
        Product(name: "Cross-country adidas Men's hoodie SUPER...", imageName: "product4", currentPrice: 92.30, originalPrice: 139.99, rating: 4.8, purchaseCount: 25, discount: "-12%", isTop: false)
    ]
    
    let gridColumns = [GridItem(.flexible()), GridItem(.flexible())]
    let categoryColumns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HomeTabBar(products: products)
                
                ScrollView {
                    VStack(spacing: 36) {
                        VStack(spacing: 24) {
                            bannerCarousel
                            categoriesGrid
                            
                            Button {
                                selectedTab = 1
                            } label: {
                                HStack {
                                    Image(systemName: "square.grid.2x2")
                                    Text("See all categories")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.navyBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color(.systemGray6))
                                .cornerRadius(25)
                            }
                            .padding(.horizontal)
                        }
                        
                        VStack(spacing: 32) {
                            
                            productSection
                            
                            Button(action: {} ) {
                                HStack {
                                    Image(systemName: "arrow.clockwise")
                                    Text("Load 8 more")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.navyBlue)
                                .cornerRadius(25)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
    
    
    private var bannerCarousel: some View {
        TabView {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(colors: [.pink, .purple], startPoint: .leading, endPoint: .trailing))
                
                Text("Music sounds better in headphones")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding()
            }
            .padding(.horizontal)
        }
        .frame(height: 150)
        .tabViewStyle(.page)
        .padding(.vertical)
    }
    
    
    private var categoriesGrid: some View {
        LazyVGrid(columns: categoryColumns, spacing: 20) {
            ForEach(categories) { category in
                VStack(spacing: 8) {
                    Text(category.emoji)
                        .font(.system(size: 32))
                        .frame(width: 70, height: 70)
                        .background(Color(.systemGray6), in: Circle())
                    
                    Text(category.name)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
        }
        .padding(.horizontal)
    }
    
    
    private var productSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Top products on sale")
                    .font(.title2.bold())
                Image(systemName: "chevron.right")
                    .font(.body.bold())
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: gridColumns, spacing: 24) {
                ForEach(products) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal)
        }
    }
}


struct ProductCardView: View {
    let product: Product
    
    @EnvironmentObject private var cart: CartStore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .top) {
                Color.cardBackground
                    .frame(height: 160)
                    .cornerRadius(12)
                
                
                NavigationLink {
                    ProductDetailsView(product: product)
                } label: {
                    Image(product.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .frame(width: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                
                HStack(alignment: .top) {
                    if product.isTop {
                        Text("Top")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 4)
                            .background(Color.yellow)
                            .clipShape(Capsule())
                    }
                        
                    Text(product.discount)
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .clipShape(Capsule())
                    
                    Spacer()
                    
                    Button(action: {} ) {
                        Image(systemName: "heart")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                }
                .padding(8)
            }
            
            HStack(spacing: 6) {
                Text("$\(String(format: "%.2f", product.currentPrice))")
                    .font(.body.bold())
                
                Text("$\(String(format: "%.2f", product.originalPrice))")
                    .font(.caption.bold())
                    .foregroundColor(.gray)
                    .strikethrough()
            }
                        
            Text(product.name)
                .font(.caption)
                .lineLimit(2)
                .frame(height: 32, alignment: .leading)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                
                Text(String(format: "%.1f", product.rating))
                    .font(.caption.bold())
                
                Text("\(product.purchaseCount) people bought")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
                
            Button {
                cart.toggle(product)
            } label: {
                HStack {
                    Image(systemName: cart.contains(product) ? "cart.badge.minus" : "plus")
                    Text(cart.contains(product) ? "Remove from cart" : "Add to cart")
                }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(cart.contains(product) ? .red : Color.navyBlue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.navyBlue, lineWidth: 1)
                )
            }
            .padding(.top, 8)
        }
    }
}


struct MainTabView: View {
    @StateObject private var cart = CartStore()
    @StateObject private var wishlist = WishlistStore()
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "storefront")
                }
                .tag(0)
            
            NavigationStack {
                CategoriesView()
            }
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2")
                }
                .tag(1)
            
            NavigationStack {
                CartView()
            }
                .tabItem {
                    Label("Cart", systemImage: "cart")
                }
                .badge(cart.totalItems == 0 ? nil : String(cart.totalItems))
                .tag(2)
                        
            Text("Wishlist")
                .tabItem {
                    Label("Wishlist", systemImage: "heart")
                }
                .tag(3)
            
            Text("Profile")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(4)
        }
        .tint(Color.blue)
        .environmentObject(cart)
        .environmentObject(wishlist)
    }
}

#Preview {
    MainTabView()
}
