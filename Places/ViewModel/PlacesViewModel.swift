//
//  PlacesViewModel.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import SwiftUI
import Combine

@MainActor
class PlacesViewModel: ObservableObject {
    
    @Published private(set) var isLoading = false
    
    @Published var isError: Bool = false
    @Published private(set) var errorStatus: PlaceVMError = .none
    private(set) var errorMessage = ""
    
    @Published var searchText = ""
    @Published private(set) var locations = [ApiResponse.Locations]()
    
    private var serverResponse = [ApiResponse.Locations]()
    private var cancellables = Set<AnyCancellable>()
    
    private var networkFetcher: NetworkFetchingProtocol
    private var deepLinkOpner: DeepLinkServiceProtocol
    
    init(
        networkFetcher: NetworkFetchingProtocol,
        deepLinkOpener: DeepLinkServiceProtocol
    ) {
        self.networkFetcher = networkFetcher
        self.deepLinkOpner = deepLinkOpener
    }
    
    //MARK: - network request
    func load() async {
        isLoading = true
        
        do {
            let response: ApiResponse = try await networkFetcher.fetch(for: .abn)
            serverResponse = response.locations
            locations = serverResponse
            errorStatus = .none
            isLoading = false
        } catch is CancellationError {
            // cancel error ignore
        } catch let err as NetworkError {
            errorStatus = .error(message: err.errorDescription)
            isLoading = false
        } catch {
            errorStatus = .error(message: error.localizedDescription)
            isLoading = false
        }
    }
    
    //MARK: - filter
    func filter(with text: String) async {
        guard !text.isEmpty else {
            locations = serverResponse
            return
        }
        
        isLoading = true
        
        do {
            let response: WikipediaPlaceSearchResponse =  try await networkFetcher.fetch(for: .wiki(searchKey: text))
            locations = WikipediaFilter.filter(from: response)
            errorStatus = .none
            isLoading = false
        } catch is CancellationError {
            // cancel error ignore
        } catch let err as NetworkError {
            errorStatus = .error(message: err.errorDescription)
            isLoading = false
        } catch {
            errorStatus = .error(message: error.localizedDescription)
            isLoading = false
        }
    }
    
    func openWikipedia(lat: Double, long: Double, title: String) {
        guard let url = URL(string: "wikipedia://places?lat=\(lat)&lon=\(long)&title=\(title)") else { return }
        do {
            try deepLinkOpner.open(url: url)
            errorStatus = .none
        } catch let err as DeepLinkError {
            errorStatus = .error(message: err.localizedDescription)
        } catch {
            errorStatus = .error(message: error.localizedDescription)
        }
    }
}

enum PlaceVMError: Equatable {
    case error(message: String)
    case none
    
    var description: String {
        switch self {
        case .error(let message): message
        case .none: ""
        }
    }
}
