//
//  CheckoutStatusOverlay.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 11/09/2026.
//

import SwiftUI

enum CheckoutStatus: Identifiable, Equatable, Codable {
    case awaiting
    case success(estimatedDelivery: String)
    case error(message: String, code: String)
    
    var id: String {
        switch self {
        case .awaiting:
            return "awaiting"
        case .success:
            return "success"
        case .error:
            return "error"
        }
    }
}



struct CheckoutStatusOverlay: View {
    let status: CheckoutStatus
    var onClose: () -> Void = {}
    var onPrimaryAction: () -> Void = {}
    var onSecondaryAction: () -> Void = {}
    
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .transition(.opacity)
            
            VStack {
                switch status {
                case .awaiting:
                    awaitingCard
                case .success(let deliveryDate):
                    successCard(deliveryDate: deliveryDate)
                case .error(let message, let code):
                    errorCard(message: message, code: code)
                }
            }
            .transition(.scale(scale: 0.95).combined(with: .opacity))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: status)
    }
    
    
    
    private var awaitingCard: some View {
        VStack(spacing: 20) {
            ProgressView()
                .controlSize(.large)
                .tint(.secondary)
                .padding(.top, 12)
            
            VStack(spacing: 12) {
                Text("Waiting for payment confirmation...")
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.primary)
                
                Text("We are connecting with your bank. It takes less than one minute. Don't close the app")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(2)
            }
        }
        .padding(28)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 32)
    }
    
    
    
    private func successCard(deliveryDate: String) -> some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(.systemGray3))
                }
            }
            .padding(.bottom, -12)
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(Color(.systemGreen))
            
            VStack(spacing: 6) {
                Text("Your order has been accepted!")
                    .font(.title3).fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Track the status of the order on Profile page")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            HStack(spacing: 4) {
                Text("Estimated delivery time:")
                    .foregroundColor(.secondary)
                Text(deliveryDate)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
            .font(.footnote)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.vertical, 4)
            
            VStack(spacing: 16) {
                Button(action: onPrimaryAction) {
                    Text("Continue shopping")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.navyBlue, in: Capsule())
                }
                
                Button(action: onSecondaryAction) {
                    Text("My orders")
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            Capsule()
                                .stroke(Color(.systemGray3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 28)
    }
    
    
    
    private func errorCard(message: String, code: String) -> some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(.systemGray3))
                }
            }
            .padding(.bottom, -12)
            
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 56))
                .foregroundColor(Color(.systemRed))
            
            VStack(spacing: 6) {
                Text("Payment Failed")
                    .font(.system(size: 19, weight: .bold))
                
                Text("\(message) Error code:\n\(code)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Text("Use another payment method or add money to your current one")
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.vertical, 4)
            
            VStack(spacing: 12) {
                Button(action: onPrimaryAction) {
                    Text("Try again")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.navyBlue, in: Capsule())
                }
                
                Button(action: onSecondaryAction) {
                    Text("Go Home")
                        .font(.body)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .overlay(
                            Capsule()
                                .stroke(Color(.systemGray3), lineWidth: 1)
                        )
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 28)
    }
}

#Preview("Awaiting payment") {
    CheckoutStatusOverlay(status: .awaiting)
}

#Preview("Order success") {
    CheckoutStatusOverlay(
        status: .success(estimatedDelivery: "Nov 24, 2027")
    )
}

#Preview("Checkout error") {
    CheckoutStatusOverlay(
        status: .error(
            message: "Not enough balance.",
            code: "CSC_7200011"
        )
    )
}
