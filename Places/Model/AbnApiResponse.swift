//
//  AbnApiResponse.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import Foundation

struct ApiResponse: Codable {
    let locations: [Locations]
    
    struct Locations: Identifiable, Codable {
        var id: UUID = UUID()
        let name: String?
        let lat: Double
        let long: Double
        
        enum CodingKeys: String, CodingKey {
            case name
            case lat
            case long
        }
    }
}
