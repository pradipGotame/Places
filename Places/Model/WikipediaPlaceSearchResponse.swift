//
//  WikipediaPlaceSearchResponse.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import Foundation

struct WikipediaPlaceSearchResponse: Decodable {
    let query: Query

    struct Query: Decodable {
        let pages: [String: Page]
    }

    struct Page: Decodable {
        let title: String
        let coordinates: [Coordinate]?
        let description: String?
    }

    struct Coordinate: Decodable {
        let lat: Double
        let lon: Double
    }
}
