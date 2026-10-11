//
//  CardBadge.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 11/10/2026.
//

import SwiftUI

struct CardBrandBadge: View {
    let brand: CardBrand

    var body: some View {
        Text(brand.badgeText)
            .font(.system(size: 10, weight: .heavy))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .frame(minWidth: 38)
            .background(brand.badgeColor, in: RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    HStack {
        CardBrandBadge(brand: .visa)
        CardBrandBadge(brand: .mastercard)
    }
    .padding()
}
