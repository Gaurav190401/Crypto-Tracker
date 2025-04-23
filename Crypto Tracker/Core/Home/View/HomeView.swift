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
            ZStack {
                VStack(spacing: 8) {
                    header
                    
                    SearchBarView(searchText: $vm.searchText)
                    
                    if vm.listingType {
                        columnHeaders
                    }
                    
                    if vm.filteredCoins.isEmpty && !vm.isLoading  {
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
                .blur(radius: vm.isLoading ? 3 : 0)
                
                if vm.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    loadingView
                }
            }
        }
    }
}
