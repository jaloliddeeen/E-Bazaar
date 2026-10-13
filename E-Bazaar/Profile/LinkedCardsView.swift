//
//  LinkedCardsView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 13/09/2026.
//

import SwiftUI

struct CreditCard: Identifiable, Hashable, Codable {
    var id = UUID()
    let brand: String
    let last4: String
    let expiry: String
    var isDefault: Bool
}

struct LinkedCardsView: View {
    @State private var cards: [CreditCard] = [
        CreditCard(brand: "Visa", last4: "3421", expiry: "08/30", isDefault: true),
        CreditCard(brand: "Mastercard", last4: "4211", expiry: "01/32", isDefault: false)
    ]
    @State private var selectedCardForAction: CreditCard? = nil
    @State private var showAddCardSheet = false
    
    var body: some View {
        List {
            Section {
                ForEach($cards) { $card in
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(card.brand == "Visa" ? Color.blue : Color.orange.opacity(0.8))
                                .frame(width: 48, height: 32)
                            
                            Text(card.brand.prefix(4))
                                .font(.caption.bold())
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Text("\(card.brand) **** \(card.last4)")
                                    .font(.subheadline.weight(.semibold))
                                
                                if card.isDefault {
                                    Text("Default")
                                        .font(.caption.bold())
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color(.systemGray5), in: Capsule())
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Text(card.expiry)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            selectedCardForAction = card
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.body.bold())
                                .foregroundStyle(.secondary)
                                .frame(width: 32, height: 32)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                Button {
                    showAddCardSheet = true
                } label: {
                    HStack {
                        Spacer()
                        Label("Add new", systemImage: "plus")
                            .font(.headline)
                            .foregroundStyle(Color.accentColor)
                        Spacer()
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Linked cards")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog(
            selectedCardForAction.map { "\($0.brand) **** \($0.last4)"} ?? "",
            isPresented: Binding(
                get: { selectedCardForAction != nil },
                set: { if !$0 { selectedCardForAction = nil} }
            ),
            titleVisibility: .visible
        ) {
            if let card = selectedCardForAction {
                if !card.isDefault {
                    Button("Set as default") {
                        setDefaultCard(card)
                    }
                }
                
                Button("Delete card", role: .destructive) {
                    deleteCard(card)
                }
            }
        }
    }
    
    
    
    private func setDefaultCard(_ targetCard: CreditCard) {
        for i in cards.indices {
            cards[i].isDefault = (cards[i].id == targetCard.id)
        }
    }
    
    private func deleteCard(_ targetCard: CreditCard) {
        cards.removeAll { $0.id == targetCard.id}
    }
}

#Preview {
    NavigationStack {
        LinkedCardsView()
    }
}
