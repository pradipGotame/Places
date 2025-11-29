//
//  DeepLinkService.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import Foundation
import UIKit

protocol DeepLinkServiceProtocol {
    func open(url: URL) throws
}

class DeepLinkService: DeepLinkServiceProtocol {
    func open(url: URL) throws {
        guard url.scheme == DeepLinkError.invalidScheme.paramTag else {
            throw DeepLinkError.invalidScheme
        }
        
        guard url.host() == DeepLinkError.invalidHost.paramTag else {
            throw DeepLinkError.invalidHost
        }
        
        let absoluteString = url.absoluteString
        guard absoluteString.contains(DeepLinkError.missingLattitude.paramTag) else {
            throw DeepLinkError.missingLattitude
        }
        guard absoluteString.contains(DeepLinkError.missingLongitude.paramTag) else {
            throw DeepLinkError.missingLongitude
        }
        guard absoluteString.contains(DeepLinkError.missingTitle.paramTag) else {
            throw DeepLinkError.missingTitle
        }
        
        UIApplication.shared.open(url)
    }
}

enum DeepLinkError: Error {
    case invalidScheme
    case invalidHost
    case missingLattitude
    case missingLongitude
    case missingTitle
    
    var localizedDescription: String {
        switch self {
        case .invalidScheme: "URL scheme doesnot match the expected `wikipedia`"
        case .invalidHost: "URL host doesnot match the `place`"
        case .missingLattitude: "URL missing `lat`"
        case .missingLongitude: "URL missing `lon` parameter"
        case .missingTitle: "URL missing `title` parameter"
        }
    }
    
    var paramTag: String {
        switch self {
        case .invalidScheme: "wikipedia"
        case .invalidHost: "places"
        case .missingLattitude: "lat="
        case .missingLongitude: "lon="
        case .missingTitle: "title="
        }
    }
}
