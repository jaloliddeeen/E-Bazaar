//
//  OpenDisputeView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 22/09/2026.
//

import SwiftUI
import PhotosUI

struct OpenDisputeView: View {
    let order: CustomerOrder
    var onSubmit: () -> Void = {}
    @Environment(\.dismiss) private var dismiss
    
    @State private var disputeTitle: String = ""
    @State private var detailedDescription: String = ""
    @State private var selectedReasons: Set<String> = []
    
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    private let predefinedReasons: [String] = [
        "It's not what I expected",
        "It's broken",
        "It looks very bad",
        "My address was wrong",
        "Delivery box was wrong"
    ]
    
    private var isFormValid: Bool {
        !disputeTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !detailedDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !selectedReasons.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent("Order ID", value: order.id)
                    LabeledContent("Status", value: order.status.rawValue)
                } header: {
                    Text("Order info")
                }
                
                Section {
                    TextField("What's the dispute about", text: $disputeTitle)
                } header: {
                    Text("Title")
                }
                
                Section {
                    TextField("Write briefly about the situation", text: $detailedDescription, axis: .vertical)
                        .lineLimit(4...8)
                } header: {
                    Text("Dispute description")
                }
                
                Section {
                    ForEach(predefinedReasons, id: \.self) { reason in
                        Button {
                            if selectedReasons.contains(reason) {
                                selectedReasons.remove(reason)
                            } else {
                                selectedReasons.insert(reason)
                            }
                        } label: {
                            HStack {
                                Text(reason)
                                    .foregroundStyle(Color(.label))
                                
                                Spacer()
                                
                                if selectedReasons.contains(reason) {
                                    Image(systemName: "checkmark")
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(Color.accentColor)
                                }
                            }
                        }
                    }
                } header: {
                    Text("Tell us the reason")
                } footer: {
                    Text("Select all reasons that apply to your dispute")
                }
                
                Section {
                    PhotosPicker(
                        selection: $selectedPhotoItems,
                        maxSelectionCount: 5,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label (
                            selectedImages.isEmpty ? "Add photos" : "Add more photos",
                            systemImage: "photo.badge.plus"
                        )
                    }
                    
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(selectedImages.indices, id: \.self) { index in
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 72, height: 72)
                                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                withAnimation {
                                                    selectedImages.remove(at: index)
                                                    if index < selectedPhotoItems.count {
                                                        selectedPhotoItems.remove(at: index)
                                                    }
                                                }
                                            } label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundStyle(.white, Color(.systemGray))
                                                    .font(.title3)
                                            }
                                            .padding(2)
                                        }
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                } header: {
                    Text("Photos")
                } footer: {
                    Text("Attach max 5 photos as evidence")
                }
            }
            .navigationTitle("Open dispute")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Submit") {
                        submitDispute()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            
            .onChange(of: selectedPhotoItems) { _, newItems in
                Task { @MainActor in
                    var loadedImages: [UIImage] = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let img = UIImage(data: data) {
                            loadedImages.append(img)
                        }
                    }
                    withAnimation {
                        selectedImages = loadedImages
                    }
                }
            }
        }
    }
    
    private func submitDispute() {
        onSubmit()
        dismiss()
    }
}

#Preview("Open Dispute") {
    OpenDisputeView(order: CustomerOrder(
        id: "458924",
        status: .delivered,
        statusDescription: "The order has been delivered to the post office",
        estimatedDelivery: "May 13",
        deliveryAddress: "Ölrainstraße 9, Bregenz, Vorarlberg, Austria, 6900",
        tab: .archive,
        items: [
            OrderItem(
                title: "Teapot Kukmara stainless steel, with a Whistle, 3 liters",
                price: 10.99,
                quantity: 1,
                color: "Black",
                size: "36-40",
                imageName: "mug.fill"
            )
        ],
        discount: 0.56,
        deliveryCost: 16.78
    ), onSubmit: {}
    )
}
