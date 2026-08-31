//
//  PaymentMethodSelectionSheet.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct PaymentMethodSelectionSheet: View {
    @Binding var cards: [PaymentCard]
    @Binding var selection: PaymentCard?
    @Environment(\.dismiss) private var dismiss
    @State private var isAddingCard = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cards) { card in
                        cardRow(card)
                    }

                    Button {
                        isAddingCard = true
                    } label: {
                        Label("Add new card", systemImage: "plus")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.navyBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                }
                .padding(20)
            }
            .navigationTitle("Changing payment method")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.footnote.bold())
                            .foregroundColor(.secondary)
                            .padding(8)
                            .background(Color(.systemGray5), in: Circle())
                    }
                    .accessibilityLabel("Close")
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .sheet(isPresented: $isAddingCard) {
            PlaceholderEntrySheet(title: "New card", prompt: "Card number") { text in
                let newCard = PaymentCard(brand: .visa, last4: String(text.suffix(4)), expiry: "--/--")
                cards.append(newCard)
                selection = newCard
            }
        }
    }

    private func cardRow(_ card: PaymentCard) -> some View {
        let isSelected = card.id == selection?.id

        return Button {
            selection = card
            dismiss()
        } label: {
            HStack(spacing: 12) {
                CardBrandBadge(brand: card.brand)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(card.brand.rawValue) \(card.maskedNumber)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.primary)
                    Text(card.expiry)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .navyBlue : Color(.systemGray4))
            }
            .padding(16)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

private struct PaymentMethodSelectionPreviewHost: View {
    @State private var cards = PaymentCard.sampleData
    @State private var selection: PaymentCard? = PaymentCard.sampleData.first
    var body: some View {
        PaymentMethodSelectionSheet(cards: $cards, selection: $selection)
    }
}

#Preview {
    PaymentMethodSelectionPreviewHost()
}
