//
//  CartStore.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 04/09/2026.
//

import Foundation
import Combine
import SwiftUI

final class CartStore: ObservableObject {
    @Published private(set) var quantities: [UUID: Int] = [:]
    @Published private(set) var products: [UUID: Product] = [:]
    @Published private(set) var selectedIDs: Set<UUID> = []
    @Published private(set) var variants: [UUID: (color: String, size: String)] = [:]
    
    @Published var items: [CartView] = []
    
    func clearCart() {
        quantities.removeAll()
        products.removeAll()
        selectedIDs.removeAll()
        variants.removeAll()
        items.removeAll()
    }
    
    var totalItems: Int {
        quantities.values.reduce(0, +)
    }
    
    func contains(_ product: Product) -> Bool {
        quantities[product.id] != nil
    }
    
    func add(_ product: Product, quantity: Int = 1, color: String = "Black", size: String = "36-37") {
        quantities[product.id, default: 0] += max(quantity, 1)
        products[product.id] = product
        variants[product.id] = (color, size)
        selectedIDs.insert(product.id)
    }
    
    func remove(_ product: Product) {
        quantities[product.id] = nil
        products[product.id] = nil
        variants[product.id] = nil
        selectedIDs.remove(product.id)
    }
    
    func toggle(_ product: Product, quantity: Int = 1, color: String = "Black", size: String = "36-37") {
        if contains(product) {
            remove(product)
        } else {
            add(product, quantity: quantity, color: color, size: size)
        }
    }
    
    func setQuantity(_ quantity: Int, for product: Product) {
        quantities[product.id] = max(quantity, 1)
    }
    
    func setSelected(_ isSelected: Bool, for product: Product) {
        if isSelected { selectedIDs.insert(product.id) } else { selectedIDs.remove(product.id)}
    }
    
    func quantityBinding(for product: Product) -> Binding<Int> {
        Binding (
            get: { self.quantities[product.id] ?? 1 },
            set: { self.setQuantity($0, for: product) }
        )
    }
    
    func selectionBinding(for product: Product) -> Binding<Bool> {
        Binding(
            get: { self.selectedIDs.contains(product.id) },
            set: { self.setSelected($0, for: product) }
        )
    }
    
    
    var lineItems: [(product: Product, quantity: Int)] {
        quantities.compactMap { id, qty in
            guard let product = products[id] else { return nil }
            return (product, qty)
         }
    }
    
    var selectedLineItems: [(product: Product, quantity: Int)] {
        lineItems.filter { selectedIDs.contains($0.product.id) }
    }
    
    var selectedItemCount: Int {
        selectedLineItems.reduce(0) { $0 + $1.quantity }
    }
    
    var subTotal: Double {
        selectedLineItems.reduce(0) { $0 + $1.product.currentPrice * Double($1.quantity)}
    }
    
    var discount: Double { selectedLineItems.isEmpty ? 0 : 0.56 }
    var deliveryCost: Double { selectedLineItems.isEmpty ? 0 : 16.78 }
    var overall: Double { subTotal + deliveryCost - discount }
 }
