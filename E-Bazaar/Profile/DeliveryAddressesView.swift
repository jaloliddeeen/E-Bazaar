//
//  DeliveryAddressesView.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 15/09/2026.
//

import SwiftUI

struct DeliveryAddressesView: View {
    @State private var addresses: [DeliveryAddress] = [
       DeliveryAddress(
           street: "Ölrainstraße 9",
           district: "Bregenz",
           region: "Vorarlberg",
           country: "Austria",
           postcode: "6900",
           fullName: "Maximillian Fischer",
           phoneNumber: "+43 123-456-7890",
           isDefault: true
       ),
       DeliveryAddress(
           street: "Wolfurterstraße 18",
           district: "Lauterach",
           region: "Vorarlberg",
           country: "Austria",
           postcode: "6900",
           fullName: "Maximillian Fischer",
           phoneNumber: "+43 123-456-7890",
           isDefault: false
       )
   ]
    
    // Mark: Presentation States
    @State private var showAddAddressSheet = false
    @State private var addressToEdit: DeliveryAddress?
    @State private var showEditSheet = false
    
    var body: some View {
        List {
            Section {
                ForEach(addresses, id: \.self) { address in
                    AddressRow(address: address) {
                        selectDefault(address)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            deleteAddress(address)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        Button {
                            addressToEdit = address
                            showEditSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.indigo)
                    }
                }
                .onDelete(perform: deleteAddressAtOffsets)
            } footer: {
                Text("Tap an address to set it as default. Swipe left to edit or delete.")
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Delivery addresses")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddAddressSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddAddressSheet) {
            AddAddressSheet { newAddress in
                var finalAddress = newAddress
                if addresses.isEmpty { finalAddress.isDefault = true }
                withAnimation { addresses.append(finalAddress) }
            }
        }
        // Sheet for Editing Address
        .sheet(isPresented: $showEditSheet) {
            if let address = addressToEdit {
                AddAddressSheet(addressToEdit: address) { updatedAddress in
                    if let index = addresses.firstIndex(of: address) {
                        var updated = updatedAddress
                        updated.isDefault = address.isDefault
                        withAnimation { addresses[index] = updated }
                    }
                }
            }
        }
    }
    
    
    private func selectDefault(_ selected: DeliveryAddress) {
        withAnimation {
            for index in addresses.indices {
                addresses[index].isDefault = (addresses[index] == selected)
            }
        }
    }
    
    private func deleteAddress(_ address: DeliveryAddress) {
        withAnimation {
            addresses.removeAll { $0.id == address.id}
            if address.isDefault, let firstRemaining = addresses.first {
                selectDefault(firstRemaining)
            }
        }
    }
    
    private func deleteAddressAtOffsets(at offsets: IndexSet) {
        withAnimation {
            let wasDefaultDeleted = offsets.contains { addresses[$0].isDefault }
            addresses.remove(atOffsets: offsets)
            if wasDefaultDeleted, let firstRemaining = addresses.first {
                selectDefault(firstRemaining)
            }
        }
    }
}



struct AddressRow: View {
    let address: DeliveryAddress
    let onSelect: () -> Void
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(address.fullName)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(address.formattedString)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                Text(address.phoneNumber)
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            
            Spacer()
            // Native iOS Selection Checkmark
            if address.isDefault {
                Image(systemName: "checkmark")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(Color.navyBlue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        // Accessibility
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(address.fullName), \(address.formattedString), phone \(address.phoneNumber). \(address.isDefault ? "Default address." : "")")
        .accessibilityHint("Double tap to set as default delivery address.")
    }
}

#Preview("Delivery Addresses") {
    NavigationStack {
        DeliveryAddressesView()
    }
}
