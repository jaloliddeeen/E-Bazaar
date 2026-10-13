//
//  AddCardView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 10/09/2026.
//

import SwiftUI

struct PaymentCard: Hashable, Codable {
    let cardNumber: String
    let expirationDate: String
    let cvc: String
    let saveForFuture: Bool
    
    var lastFourDigits: String {
        let digits = cardNumber.filter { $0.isNumber}
        return digits.count >= 4 ? String(digits.suffix(4)) : digits
    }
}

struct AddCardView: View {
    var onSave: (PaymentCard) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var cardNumber = ""
    @State private var expirationDate = ""
    @State private var cvc = ""
    @State private var saveCard = true
    
    private var isValid: Bool {
        let cleanCardNumber = cardNumber.filter { $0.isNumber }
        return cleanCardNumber.count >= 15 && !expirationDate.isEmpty && cvc.count >= 3
    }

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Card number")
                        .font(.subheadline).fontWeight(.medium)
                    
                    HStack {
                        TextField("Type 16 digit number", text: $cardNumber)
                            .keyboardType(.numberPad)
                            .onChange(of: cardNumber) { _, newValue in
                                cardNumber = formatCardNumber(newValue)
                            }
                        
                        if let brand = detectCardBrand(cardNumber) {
                            Text(brand)
                                .font(.caption2.weight(.bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue, in: RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color(.systemGray), lineWidth: 1)
                    )
                }
                
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expiration date")
                            .font(.subheadline.weight(.medium))
                        
                        TextField("MM/YY", text: $expirationDate)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("CVC")
                            .font(.subheadline.weight(.medium))
                        
                        SecureField("XXX", text: $cvc)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 16)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                            .onChange(of: cvc) { _, newValue in
                                let digits = newValue.filter { $0.isNumber }
                                cvc = String(digits.prefix(3))
                            }
                    }
                }
                
                Toggle("Save card for future payments", isOn: $saveCard)
                    .font(.subheadline)
                    .tint(.accentColor)
                    .padding(.top, 4)
            }
            .padding(20)
        }
        .navigationTitle("Adding card")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            addButton
        }
    }
    
    
    private var addButton: some View {
        Button {
            let card = PaymentCard(cardNumber: cardNumber, expirationDate: expirationDate, cvc: cvc, saveForFuture: saveCard)
            onSave(card)
            dismiss()
        } label: {
            Text("Add")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isValid ? Color.navyBlue : Color(.systemGray4))
                .clipShape(Capsule())
        }
        .disabled(!isValid)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bar)
    }
    
    private func formatCardNumber(_ input: String) -> String {
        let digits = input.filter { $0.isNumber }
        var result = ""
        for (index, character) in digits.enumerated() {
            if index > 0 && index % 4 == 0 && index < 16 {
                result.append(" ")
            }
            
            if index < 16 {
                result.append(character)
            }
        }
        return result
     }
    
    
    private func detectCardBrand(_ number: String) -> String? {
        let digits = number.filter { $0.isNumber }
        if digits.hasPrefix("4") { return "Visa" }
        if digits.hasPrefix("5") { return "MasterCard" }
        return nil
    }
}

#Preview {
    NavigationStack {
        AddCardView { _ in }
    }
}
