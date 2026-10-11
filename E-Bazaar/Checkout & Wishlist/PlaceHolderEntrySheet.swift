//
//  PlaceHolderEntrySheet.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import SwiftUI

struct PlaceholderEntrySheet: View {
    let title: String
    let prompt: String
    var onSave: (String) -> Void

    @State private var text = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form { TextField(prompt, text: $text) }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") { onSave(text); dismiss() }
                            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    PlaceholderEntrySheet(title: "Delivery address", prompt: "Enter your address") { _ in }
}
