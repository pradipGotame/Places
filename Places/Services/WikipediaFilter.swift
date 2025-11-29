//
//  WikipediaFilter.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

enum WikipediaFilter {
    static func filter(from response: WikipediaPlaceSearchResponse) -> [ApiResponse.Locations] {
        response.query.pages.compactMap { (_, page) -> ApiResponse.Locations? in
            guard let coord = page.coordinates?.first else { return nil }
            let name = [page.title, page.description]
                    .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
                    .joined(separator: ", ")
           return ApiResponse.Locations(name: name, lat: coord.lat, long: coord.lon)
        }
    }
}
