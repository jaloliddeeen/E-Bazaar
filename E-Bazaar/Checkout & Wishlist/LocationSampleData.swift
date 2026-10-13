//
//  LocationSampleData.swift
//  E-Bazaar
//
//  Created by Jaloliddin Esonboyev on 09/09/2026.
//

import Foundation

struct Country: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let dialCode: String
}

enum LocationSampleData {
    static let countries: [Country] = [
        Country(id: "AL", name: "Albania", dialCode: "+355"),
        Country(id: "AD", name: "Andorra", dialCode: "+376"),
        Country(id: "AT", name: "Austria", dialCode: "+43"),
        Country(id: "BY", name: "Belarus", dialCode: "+375"),
        Country(id: "BE", name: "Belgium", dialCode: "+32"),
        Country(id: "BA", name: "Bosnia and Herzegovina", dialCode: "+387"),
        Country(id: "BG", name: "Bulgaria", dialCode: "+359"),
        Country(id: "HR", name: "Croatia", dialCode: "+385"),
        Country(id: "CY", name: "Cyprus", dialCode: "+357"),
        Country(id: "CZ", name: "Czech Republic", dialCode: "+420"),
        Country(id: "DK", name: "Denmark", dialCode: "+45"),
        Country(id: "EE", name: "Estonia", dialCode: "+372"),
        Country(id: "FI", name: "Finland", dialCode: "+358")
    ]
    
    static func regions(for country: Country) -> [String] {
        switch country.id {
        case "AT": return ["Vorarlberg", "Tyrol", "Salzburg", "Vienna", "Styria"]
        default: return ["\(country.name) region"]
        }
    }
    
    static func districts(for region: String) -> [String] {
        switch region {
        case "Vorarlberg": return ["Bregenz", "Dornbirn", "Feldkirch", "Bludenz"]
        default: return ["\(region) district"]
        }
    }
}
