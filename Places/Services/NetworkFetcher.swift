//
//  NetworkFetcher.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import Foundation

protocol NetworkFetchingProtocol {
    func fetch<T: Decodable>(for url: Api) async throws -> T
}

class NetworkFetcher: NetworkFetchingProtocol {
    func fetch<T: Decodable>(for url: Api) async throws -> T where T : Decodable {
        guard let url = URL(string: url.path) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(status: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}

//MARK: - errors
enum NetworkError: Error, LocalizedError, Equatable {
    
    case invalidURL
    case noData
    case httpError(status: Int)
    case decoding(Error)
    case transport(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidURL:
            return "The URL provided was invalid."
        case .noData:
            return "No data returned from the server."
        case .httpError(let status):
            return "Server returned an HTTP \(status) error."
        case .decoding(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .transport(let error):
            return "Network transport error: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Equatable
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noData, .noData):
            return true
        case (.httpError(let a), .httpError(let b)):
            return a == b
        case (.decoding, .decoding):
            return true
        case (.transport, .transport):
            return true
        default:
            return false
        }
    }
}


//MARK: - urls
enum Api {
    case abn
    case wiki(searchKey: String)
    case mock
    
    var path: String {
        switch self {
        case .abn: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
        case .wiki(let searchKey): "https://en.wikipedia.org/w/api.php?action=query&generator=prefixsearch&gpssearch=\(searchKey)&gpsnamespace=0&gpslimit=24&prop=description|coordinates&list=search&srsearch=\(searchKey)&srnamespace=0&srwhat=text&srinfo=suggestion&srprop=&sroffset=0&srlimit=1&redirects=1&continue=&format=json"
        case .mock: ""
        }
    }
}
