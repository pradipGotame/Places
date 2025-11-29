//
//  ContentView.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = PlacesViewModel(
        networkFetcher: NetworkFetcher(),
        deepLinkOpener: DeepLinkService()
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section("Locations") {
                        PlaceRow(vm: vm)
                    }
                }
                .autocorrectionDisabled()
                .searchable(
                    text: $vm.searchText,
                    placement: .automatic,
                    prompt: "Search Location"
                )
                .textInputAutocapitalization(.never)
                .refreshable {
                    await vm.load()
                }
                .task(id: vm.searchText) {
                    do {
                        try await Task.sleep(nanoseconds: 6)
                        await vm.filter(with: vm.searchText)
                    } catch is CancellationError {
                      //cancel
                    } catch {
                        #if DEBUG
                        print("error -> \(error.localizedDescription)")
                        #endif
                    }
                }
                
                if vm.isLoading {
                    ProgressView()
                        .accessibilityLabel("Loading")
                }
                
                if !vm.errorMessage.isEmpty {
                    Text(vm.errorMessage)
                        .font(.caption2)
                        .foregroundStyle(.gray.opacity(0.3))
                        .accessibilityLabel(vm.errorMessage)
                }
            }
            .onChange(of: vm.errorStatus) { newValue in
                guard newValue != .none else { return }
                vm.isError = true
            }
            .alert("Error", isPresented: $vm.isError) {
                Button("OK") {
                    vm.isError = false
                }
            } message: {
                Text(vm.errorStatus.description)
            }
            .task {
                await vm.load()
            }

        }///nav
    }
}

#Preview {
    ContentView()
}
