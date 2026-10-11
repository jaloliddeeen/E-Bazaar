//
//  OrderListView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 20/09/2026.
//

import SwiftUI

enum OrderTab: String, CaseIterable, Identifiable {
    case active = "Active"
    case archive = "Archive"
    case dispute = "Dispute"
    
    var id: String { rawValue }
}

enum OrderStatus: String, CaseIterable {
    case initialPreparation = "Initial preparation"
    case processingPayment = "Processing the payment"
    case waitingForPayment = "Waiting for payment"
    case delivered = "Delivered"
    case disputed = "Disputed"
    case cancelled = "Cancelled"
    
    var tintColor: Color {
        switch self {
        case .initialPreparation:
            return Color.accentColor
        case .processingPayment:
            return .blue
        case .waitingForPayment:
            return .orange
        case .delivered:
            return .green
        case .cancelled, .disputed:
            return .red
        }
    }
}

struct OrderItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let price: Double
    let quantity: Int
    let color: String
    let size: String
    let imageName: String
}

struct CustomerOrder: Identifiable, Hashable {
    let id: String
    let status: OrderStatus
    let statusDescription: String
    let estimatedDelivery: String
    let deliveryAddress: String
    let tab: OrderTab
    let items: [OrderItem]
    let discount: Double
    let deliveryCost: Double
    var deliveryDateString: String? = nil
    var trackingNumber: String? = nil
    
    var subtotal: Double {
        items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
    
    var totalProductsCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
    
    var overallTotal: Double {
        subtotal - discount + deliveryCost
    }
}

struct OrderListView: View {
    @State private var selectedTab: OrderTab = .active
    
    @State private var orders: [CustomerOrder] = [
        CustomerOrder(
            id: "4241",
            status: .initialPreparation,
            statusDescription: "The seller has confirmed your order – he is already collecting the parcel",
            estimatedDelivery: "Until October 23",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900",
            tab: .active,
            items: [
                OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-48", imageName: "mug.fill")
            ],
            discount: 0.56,
            deliveryCost: 16.78
        ),
        
        CustomerOrder(
            id: "0987",
            status: .processingPayment,
            statusDescription: "We are verifying your transaction with your bank.",
            estimatedDelivery: "Until October 25",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Austria",
            tab: .active,
            items: [
                OrderItem(title: "Wireless Bluetooth Headphones", price: 45.00, quantity: 1, color: "Silver", size: "One Size", imageName: "headphones")
            ],
            discount: 5.00,
            deliveryCost: 0.00
        ),

        CustomerOrder(
            id: "458926",
            status: .waitingForPayment,
            statusDescription: "Please complete the checkout before your reservation expires.",
            estimatedDelivery: "Until October 27",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Austria",
            tab: .active,
            items: [
                OrderItem(title: "Smart Watch Series 8", price: 199.99, quantity: 1, color: "Midnight", size: "45mm", imageName: "applewatch")
            ],
            discount: 0.00,
            deliveryCost: 10.00
        ),
        CustomerOrder(
            id: "458924",
            status: .delivered,
            statusDescription: "The order has been delivered to the post office",
            estimatedDelivery: "May 13",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900",
            tab: .archive,
            items: [
                OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-40", imageName: "mug.fill"),
                OrderItem(title: "Pled EMA AD-0881 100% akril, 150*200", price: 22.99, quantity: 5, color: "Black", size: "36-40", imageName: "bed.double.fill")
            ],
            discount: 0.56,
            deliveryCost: 16.78,
            deliveryDateString: "Delivered on 22.09.2023",
            trackingNumber: "RA2335846384LB"
        ),
        CustomerOrder(
            id: "458925",
            status: .disputed,
            statusDescription: "A dispute has been opened for this order.",
            estimatedDelivery: "September 15",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Austria",
            tab: .archive,
            items: [
                OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-40", imageName: "mug.fill")
            ],
            discount: 0.00,
            deliveryCost: 10.00,
            deliveryDateString: "Disputed",
            trackingNumber: "RA2335846385LB"
        ),
        CustomerOrder(
            id: "458927",
            status: .delivered,
            statusDescription: "Package safely dropped at reception.",
            estimatedDelivery: "August 20",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Austria",
            tab: .archive,
            items: [
                OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-40", imageName: "mug.fill")
            ],
            discount: 2.00,
            deliveryCost: 5.00,
            deliveryDateString: "Delivered on 22.09.2023",
            trackingNumber: "RA2335846386LB"
        )

    ]
    
    private var filteredOrders: [CustomerOrder] {
        orders.filter { $0.tab == selectedTab}
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("Orders filter", selection: $selectedTab) {
                Text("Active (\(orders.filter { $0.tab == .active}.count))").tag(OrderTab.active)
                Text("Archive").tag(OrderTab.archive)
                Text("Dispute").tag(OrderTab.dispute)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .background(Color(.systemGroupedBackground))
            
            if filteredOrders.isEmpty {
                ContentUnavailableView(
                    "No \(selectedTab.rawValue) Orders",
                    systemImage: "cube.box",
                    description: Text("You don't have any orders under this section")
                )
                .frame(maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                List {
                    ForEach(filteredOrders) { order in
                        Section {
                            NavigationLink {
                                OrderDetailView(order: order)
                            } label: {
                                OrderRowView(order: order)
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .listSectionSpacing(.compact)
                .contentMargins(.top, 16, for: .scrollContent)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Orders")
    }
}

struct OrderRowView: View {
    let order: CustomerOrder
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Order ID - \(order.id)")
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                if order.tab == .archive, let dateString = order.deliveryDateString {
                    Text(dateString)
                        .font(.headline)
                        .foregroundStyle(order.status == .disputed ? .red : .primary)
                    
                    if let firstTitle = order.items.first?.title {
                        Text(firstTitle)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                } else {
                    Text(order.status.rawValue)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(order.status.tintColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(order.status.tintColor.opacity(0.1), in: Capsule())
                }
            }
            
            Spacer()
            
            if let firstItem = order.items.first {
                Image(systemName: firstItem.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .padding(12)
                    .foregroundStyle(Color.accentColor)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.vertical, 4)
    }
}

struct OrderDetailView: View {
    let order: CustomerOrder
    
    @State private var showCancelConfirmation = false
    @State private var showDisputeConfirmation = false
    @State private var copiedTrackingNumber = false
    @State private var showOpenDisputeSheet = false
    
    @State private var hasDisputed = false
    @State private var showCancelDisputeConfirmation = false
    @State private var showResolveDisputeConfirmation = false
    @Environment(\.dismiss) private var dismiss
    
    private var shouldShowDisputeBanner: Bool {
        order.status == .disputed || hasDisputed
    }
    
    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Order ID - \(order.id)")
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(order.status.rawValue)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 5)
                            .background(order.status.tintColor, in: Capsule())
                    }
                    
                    Text(order.statusDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .italic()
                    
                    if order.status == .delivered {
                        HStack(spacing: 12) {
                            Button(action: repeatOrder) {
                                Text("Repeat order")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.bordered)
                            .tint(Color.accentColor)
                            .clipShape(Capsule())
                            
                            Button(action: rateProduct) {
                                Text("Rate product")
                                    .font(.subheadline.weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                            .buttonStyle(.bordered)
                            .tint(Color.accentColor)
                            .clipShape(Capsule())
                        }
                        .padding(.top, 4)
                    }
                }
                .padding(.vertical, 4)
            }
            
            if shouldShowDisputeBanner {
                Section {
                    Text("You disputed this product. Please wait for 48 hours. We will let you know if there is something new")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Button(role: .destructive) {
                        showCancelDisputeConfirmation = true
                    } label: {
                        Label("Cancel dispute", systemImage: "xmark.circle")
                            .foregroundStyle(.red)
                    }
                    
                    Button {
                        showResolveDisputeConfirmation = true
                    } label: {
                        Label("Resolve dispute", systemImage: "checkmark.circle")
                            .foregroundStyle(.green)
                    }
                } header: {
                    Text("Dispute")
                }
            }
            
            Section {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "box.truck.fill")
                        .foregroundStyle(Color.accentColor)
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.tab == .archive ? "Delivered" : "Estimated delivery")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(order.estimatedDelivery)
                            .font(.subheadline.weight(.semibold))
                    }
                }
                .padding(.vertical, 2)
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundStyle(.red)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Delivery address")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(order.deliveryAddress)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.vertical, 2)
                
                if let tracking = order.trackingNumber {
                    HStack(alignment: .center, spacing: 12) {
                        Image(systemName: "barcode.viewfinder")
                            .foregroundStyle(Color.accentColor)
                            .font(.title3)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Track number")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            
                            Text(tracking)
                                .font(.subheadline.weight(.medium))
                        }
                        
                        Spacer()
                        
                        Button {
                            UIPasteboard.general.string = tracking
                            copiedTrackingNumber = true
                        } label: {
                            Image(systemName: copiedTrackingNumber ? "checkmark" : "doc.on.doc")
                                .foregroundStyle(copiedTrackingNumber ? .green : Color.accentColor)
                        }
                        .buttonStyle(.plain)
                        .sensoryFeedback(.success, trigger: copiedTrackingNumber)
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Section("Products (\(order.totalProductsCount))") {
                ForEach(order.items) { item in
                    HStack(spacing: 12) {
                        Image(systemName: item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .padding(10)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .foregroundStyle(Color.accentColor)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text("$\(String(format: "%.2f", item.price))")
                                    .font(.headline)
                                
                                Text("x\(item.quantity)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Text(item.title)
                                .font(.subheadline)
                                .lineLimit(2)
                            
                            Text("Color: \(item.color),    Size: \(item.size)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            Section {
                HStack {
                    Text("Products (\(order.totalProductsCount))")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("$\(String(format: "%.2f", order.subtotal))")
                }
                HStack {
                    Text("Discount")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("-$\(String(format: "%.2f", order.discount))")
                        .foregroundStyle(.green)
                }
                HStack {
                    Text("Delivery cost")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("$\(String(format: "%.2f", order.deliveryCost))")
                }
                HStack {
                    Text("Overall")
                        .font(.headline)
                    Spacer()
                    Text("$\(String(format: "%.2f", order.overallTotal))")
                        .font(.title3.bold())
                        .foregroundColor(Color.accentColor)
                }
            }
            
            Section("Help with order") {
                NavigationLink {
                    ChatDetailView(conversation: ChatConversation(
                        storeName: "Seller Support",
                        storeAvatar: "bubble.left.and.bubble.right.fill",
                        lastMessage: "How can we help with order #\(order.id)?",
                        timeString: "Now"
                    ))
                } label: {
                    Label("Chat with the seller", systemImage: "message.fill")
                        .foregroundStyle(Color.accentColor)
                }
                
                if order.tab == .active {
                    Button(role: .destructive) {
                        showCancelConfirmation = true
                    } label: {
                        Label("Cancel the order", systemImage: "xmark.circle.fill")
                            .foregroundStyle(.red)
                    }
                } else if !shouldShowDisputeBanner {
                    Button {
                        showDisputeConfirmation = true
                    } label: {
                        Label("Open dispute", systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(.compact)
        .contentMargins(.top, 8, for: .scrollContent)
        .contentMargins(.bottom, 12, for: .scrollContent)
        .navigationTitle("Order details")
        .navigationBarTitleDisplayMode(.inline)
        
        .confirmationDialog(
            "Cancel order #\(order.id)?",
            isPresented: $showCancelConfirmation,
            titleVisibility:.visible
        ) {
            Button("Cancel order", role: .destructive) {
                dismiss()
            }
            Button("Keep order", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel this order? This action cannot be undone.")
        }
        
        .confirmationDialog(
            "Open dispute for order #\(order.id)?",
            isPresented: $showDisputeConfirmation,
            titleVisibility: .visible
        ) {
                Button("Open dispute", role: .destructive) {
                    showOpenDisputeSheet = true
                }
                Button("Cancel", role: .cancel) {}
        } message: {
            Text("Opening a dispute will notify our support team to step in and mediate with the seller.")
        }
        
        .sheet(isPresented: $showOpenDisputeSheet) {
            OpenDisputeView(order: order) {
                withAnimation { hasDisputed = true }
            }
        }
        
        .confirmationDialog(
            "Cancel dispute?",
            isPresented: $showCancelDisputeConfirmation,
            titleVisibility: .visible
        ) {
            Button("Cancel dispute", role: .destructive) {
                withAnimation { hasDisputed = false }
            }
            Button("Keep dispute", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel your dispute? This will close the case and you won't be able to reopen it.")
        }
        
        .confirmationDialog(
            "Resolve dispute?",
            isPresented: $showResolveDisputeConfirmation,
            titleVisibility: .visible
        ) {
            Button("Mark as resolved") {
                withAnimation { hasDisputed = false }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("By resolving this dispute, you confirm the issue has been settled with the seller.")
        }
    }
    
    private func repeatOrder() {
        // Adds items back to Cart
    }
    
    private func rateProduct() {
        // Opens product rating view/sheet
    }
}


#Preview("Orders list") {
    NavigationStack {
        OrderListView()
    }
}

#Preview("Order details") {
    NavigationStack {
        OrderDetailView(order: CustomerOrder(
            id: "4241",
            status: .initialPreparation,
            statusDescription: "The seller has confirmed your order – he is already collecting the parcel",
            estimatedDelivery: "Until October 23",
            deliveryAddress: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900",
            tab: .archive,
            items: [
                OrderItem(title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters", price: 10.99, quantity: 1, color: "Black", size: "36-40", imageName: "mug.fill"),
                OrderItem(title: "Pled EMA AD-0881 100% akril, 150*200", price: 22.99, quantity: 5, color: "Black", size: "36-40", imageName: "bed.double.fill")
            ],
            discount: 0.56,
            deliveryCost: 16.78
        ))
    }
}
