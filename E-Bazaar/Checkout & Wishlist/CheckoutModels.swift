//
//  CheckoutModels.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct DeliveryAddress: Identifiable, Equatable {
    let id = UUID()
    let line: String
}

extension DeliveryAddress {
    static let sampleData: [DeliveryAddress] = [
        DeliveryAddress(line: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900"),
        DeliveryAddress(line: "Kirchstraße 12, Salzburg, Austria, 5020")
    ]
}

enum CardBrand: String, Equatable {
    case visa = "Visa"
    case mastercard = "Mastercard"

    var badgeText: String {
        switch self {
        case .visa: "VISA"
        case .mastercard: "MC"
        }
    }

    var badgeColor: Color {
        switch self {
        case .visa: Color(red: 0.06, green: 0.15, blue: 0.5)
        case .mastercard: .orange
        }
    }
}

struct PaymentCard: Identifiable, Equatable {
    let id = UUID()
    let brand: CardBrand
    let last4: String
    let expiry: String

    var maskedNumber: String { "**** \(last4)" }
}

extension PaymentCard {
    static let sampleData: [PaymentCard] = [
        PaymentCard(brand: .visa, last4: "2505", expiry: "12/23"),
        PaymentCard(brand: .mastercard, last4: "9283", expiry: "05/27")
    ]
}
