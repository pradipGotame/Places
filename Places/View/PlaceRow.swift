//
//  PlaceRow.swift
//  Places
//
//  Created by Pradip Gotame on 29/11/2025.
//

import SwiftUI

struct PlaceRow: View {
    @ObservedObject var vm: PlacesViewModel
    var body: some View {
        LazyVStack {
            ForEach(vm.locations, id: \.id) { item in
                HStack(spacing: 8) {
                    Image(systemName: "location.north.circle.fill")
                        .foregroundStyle(.black.opacity(0.4))
                        .accessibilityLabel("Location")
                    
                    Text("\(item.name ?? "N/A")")
                        .foregroundStyle(Color.black)
                        .accessibilityLabel(item.name ?? "Unknown")
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .accessibilityLabel("next")
                }
                .padding(.vertical, 8)
                .onTapGesture {
                    vm.openWikipedia(lat: item.lat, long: item.long, title: item.name ?? "Unknown")
                }
            }
        }///lazy
    }
}

#Preview {
    PlaceRow(vm: PlacesViewModel(networkFetcher: NetworkFetcher(), deepLinkOpener: DeepLinkService()))
}
