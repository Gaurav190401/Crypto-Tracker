//
//  HomeView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var vm: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                header

                SearchBarView(searchText: $vm.searchText)
                
                if vm.listingType {
                    columnHeaders
                }
                
                if vm.isLoading {
                    loadingView
                } else if vm.filteredCoins.isEmpty {
                    nodataView
                } else {
                    if vm.listingType {
                        coinsList
                    } else {
                        coinsGrid
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}
