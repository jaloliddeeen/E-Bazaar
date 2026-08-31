//
//  StringPickerSheet.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct StringPickerSheet: View {
    let title: String
    let options: [String]
    @Binding var selection: String?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List(options, id: \.self) { option in
                Button {
                    selection = option
                    dismiss()
                } label: {
                    HStack {
                        Text(option)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if option == selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped) 
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote.bold())
                            .foregroundColor(.secondary)
                            .padding(8)
                            .background(Color(.systemGray5), in: Circle())
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

private struct StringPickerPreviewHost: View {
    @State private var selection: String? = "Austria"
    
    var body: some View {
        StringPickerSheet(
            title: "Country",
            options: LocationSampleData.countries.map(\.name),
            selection: $selection
        )
    }
}

#Preview {
    StringPickerPreviewHost()
}
