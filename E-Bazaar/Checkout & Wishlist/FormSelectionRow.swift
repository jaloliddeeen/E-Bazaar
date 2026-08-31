//
//  FormSelectionRow.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct FormSelectionRow: View {
    let label: String
    let placeholder: String
    let value: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(value ?? placeholder)
                    .foregroundColor(value == nil ? .secondary : .primary)
                
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct FormTextRow: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
    }
}


private struct FormTextRowPreviewHost: View {
    @State private var text = ""
    
    var body: some View {
        Form {
            FormTextRow(label: "Address", placeholder: "Enter your address", text: $text)
        }
    }
}

private struct FormSelectionRowPreviewHost: View {
    @State private var selectedCountry: String? = nil
    
    var body: some View {
        Form {
            FormSelectionRow(
                label: "Country",
                placeholder: "Choose your country",
                value: selectedCountry
            ) {
                selectedCountry = "Austria"
            }
        }
    }
}

#Preview("Selection Row") {
    FormSelectionRowPreviewHost()
}

#Preview("Text Row") {
    FormTextRowPreviewHost()
}
