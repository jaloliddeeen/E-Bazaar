//
//  AddAddressSheet.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct DeliveryAddress: Hashable {
    let street: String
    let district: String
    let region: String
    let country: String
    let postcode: String
    let fullName: String
    let phoneNumber: String
    
    var formattedString: String {
        "\(street), \(district), \(region), \(country), \(postcode)"
    }
}

struct AddAddressSheet: View {
    var onSave: (DeliveryAddress) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var countryName: String?
    @State private var region: String?
    @State private var district: String?
    @State private var street = ""
    @State private var postcode = ""
    @State private var fullName = ""
    @State private var phoneNumber = ""

    @State private var isPickingCountry = false
    @State private var isPickingRegion = false
    @State private var isPickingDistrict = false
    
    private var selectedCountry: Country? {
        LocationSampleData.countries.first { $0.name == countryName }
    }
    
    private var dialCode: String { selectedCountry?.dialCode ?? "+48" }
    
    private var isValid: Bool {
        countryName != nil && region != nil && district != nil &&
        !street.trimmingCharacters(in: .whitespaces).isEmpty &&
        !postcode.trimmingCharacters(in: .whitespaces).isEmpty &&
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    FormSelectionRow(label: "Country", placeholder: "Choose your country", value: countryName) {
                        isPickingCountry = true
                    }

                    FormSelectionRow(label: "Region", placeholder: "Choose your region", value: region) {
                        isPickingRegion = true
                    }
                    .disabled(selectedCountry == nil)
                    .opacity(selectedCountry == nil ? 0.5 : 1)

                    FormSelectionRow(label: "District", placeholder: "Choose your district", value: district) {
                        isPickingDistrict = true
                    }
                    .disabled(region == nil)
                    .opacity(region == nil ? 0.5 : 1)
                }
                
                Section {
                    FormTextRow(label: "Address", placeholder: "Enter your address", text: $street)
                    FormTextRow(label: "Postcode", placeholder: "Enter your postcode", text: $postcode, keyboardType: .numberPad)
                }
                
                Section(header: Text("Recipient")) {
                    FormTextRow(label: "Full name", placeholder: "Enter your full name", text: $fullName)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone number")
                            .font(.subheadline.weight(.medium))
                        
                        HStack(spacing: 8) {
                            Text(dialCode)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            
                            TextField("Phone number", text: $phoneNumber)
                                .keyboardType(.phonePad)
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                    }
                }
            }
            .navigationTitle("Add address")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                addButton
            }
            .sheet(isPresented: $isPickingCountry) {
                StringPickerSheet(
                    title: "Country",
                    options: LocationSampleData.countries.map(\.name),
                    selection: $countryName
                )
                .onChange(of: countryName) { oldValue, newValue in
                    region = nil
                    district = nil
                }
            }
            .sheet(isPresented: $isPickingRegion) {
                let regions = selectedCountry != nil ? LocationSampleData.regions(for: selectedCountry!) : []
                StringPickerSheet(
                    title: "Region",
                    options: regions,
                    selection: $region
                )
                .onChange(of: region) { oldValue, newValue in
                    district = nil
                }
            }
            .sheet(isPresented: $isPickingDistrict) {
                let districts = region != nil ? LocationSampleData.districts(for: region!) : []
                StringPickerSheet(
                    title: "District",
                    options: districts,
                    selection: $district
                )
            }
        }
    }
    
    private var addButton: some View {
        Button {
            let address = DeliveryAddress(
                street: street,
                district: district ?? "",
                region: region ?? "",
                country: countryName ?? "",
                postcode: postcode,
                fullName: fullName,
                phoneNumber: "\(dialCode) \(phoneNumber)"
            )
            onSave(address)
            dismiss()
        } label: {
            Text("Add address")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isValid ? Color.accentColor : Color(.systemGray4))
                .clipShape(Capsule())
        }
        .disabled(!isValid)
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.bar)
    }
}

#Preview {
    AddAddressSheet { _ in }
}
