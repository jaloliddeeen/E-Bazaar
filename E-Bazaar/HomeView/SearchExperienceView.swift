//
//  SearchExperienceView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 02/09/2026.
//

import SwiftUI

struct SearchExperienceView: View {
    
    let products: [Product]
    
    @State private var query = ""
    @State private var recentSearches = ["T-Shirt", "iPhone", "Toys"]
    @State private var isShowingSearchOptions = false
    @State private var sortOrder: SortOrder = .relevance
    
    private let trendingSearches = ["Women’s fashion", "Winter clothes", "Cardigans"]
    private let suggestedSearches = [
        "iPhone 15", "iPhone 15 Pro", "iPhone 15 Pro Max",
        "iPhone 15 Pro Max case", "iPhone 15 case"
    ]

    
    var body: some View {
        Group {
            if query.isEmpty {
                discoveryContent
            } else {
                resultsContent
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .searchable (
            text: $query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Products, categories and brand"
        )
        .searchSuggestions { searchSuggestions }
        .onSubmit(of: .search) { saveSearch(query) }
        .toolbar {
            if !query.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { isShowingSearchOptions = true } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .accessibilityLabel("Sort results")
                }
            }
        }
        .confirmationDialog("Sort results", isPresented: $isShowingSearchOptions, titleVisibility: .visible) {
            ForEach(SortOrder.allCases) { order in
                Button(order.title) { sortOrder = order }
            }
        }
    }
    
    
    private var discoveryContent: some View {
        List {
            Section("Recent searches") {
                ForEach(recentSearches, id: \.self) { term in
                    Button { select(term) } label: {
                        Label(term, systemImage: "clock.arrow.circlepath")
                    }
                    .foregroundStyle(.primary)
                }
                .onDelete { offsets in recentSearches.remove(atOffsets: offsets) }
            }
            
            Section("Trending now") {
                ForEach(trendingSearches, id: \.self) { term in
                    Button { select(term) } label: {
                        Label(term, systemImage: "magnifyingglass")
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .listStyle(.insetGrouped)
    }
    
    
    
    private var resultsContent: some View {
        ScrollView {
            if sortedProducts.isEmpty {
                emptyResults
            } else {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible())
                    ],
                    spacing: 28
                ) {
                    ForEach(sortedProducts) { product in
                        ProductCardView(product: product)
                    }
                }
                .padding(16)
                .padding(.bottom, 24)
            }
        }
        .background(Color(.systemBackground))
        .accessibilityLabel("Search results for \(query)")
    }
    
    
    private var emptyResults: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.secondary)
            
            Text("No products found").font(.headline)
            Text("Try a broader search or a different spelling.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .padding(.top, 96)
        .padding(.horizontal, 24)
    }
    
    
    @ViewBuilder
    private var searchSuggestions: some View {
        if query.isEmpty {
            ForEach(recentSearches.prefix(3), id: \.self) { term in
               Label(term, systemImage: "magnifyingglass")
                    .searchCompletion(term)
            }
        } else {
            ForEach(matchingSuggestions, id: \.self) { term in
                Label(term, systemImage: "magnifyingglass")
                    .searchCompletion(term)
            }
        }
    }
    
    
    private var matchingSuggestions: [String] {
        suggestedSearches.filter { $0.localizedCaseInsensitiveContains(query) }
    }
    
    
    private var matchingProducts: [Product] {
        products.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    
    private var sortedProducts: [Product] {
        switch sortOrder {
        case .relevance:
            return matchingProducts
        case .priceLowToHigh:
            return matchingProducts.sorted { $0.currentPrice < $1.currentPrice }
        case .priceHighToLow:
            return matchingProducts.sorted { $0.currentPrice > $1.currentPrice }
        case .topRated:
            return matchingProducts.sorted { $0.rating > $1.rating }
        }
    }
    
    
    private func select(_ term: String) {
        query = term
        saveSearch(term)
    }
    
    
    private func saveSearch(_ term: String) {
        let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTerm.isEmpty else { return }
        
        recentSearches.removeAll { $0.caseInsensitiveCompare(trimmedTerm) == .orderedSame }
        recentSearches.insert(trimmedTerm, at: 0)
    }
}

private enum SortOrder: String, CaseIterable, Identifiable {
    case relevance, priceLowToHigh, priceHighToLow, topRated
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .relevance: "Relevance"
        case .priceLowToHigh: "Price low to high"
        case .priceHighToLow: "Price high to low"
        case .topRated: "Top rated"
        }
    }
}

#Preview {
    NavigationStack {
        SearchExperienceView(products: [])
    }
}
