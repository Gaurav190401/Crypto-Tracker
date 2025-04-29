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
        NavigationStack {
            ZStack {
                VStack(spacing: 8) {
                    header
                    
                    SearchBarView(searchText: $vm.searchText)
                    
                    if vm.filteredCoins.isEmpty && !vm.isLoading  {
                        nodataView
                    } else {
                        refreshableContentView
                    }
                }
                .navigationBarHidden(true)
                .blur(radius: vm.isLoading ? 3 : 0)
                .navigationDestination(isPresented: $vm.showDetailView) {
                    if let coin = vm.selectedCoin {
                        CoinDetailView(id: coin.id)
                    }
                }
                if vm.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    LoadingView()
                }
            }
        }
    }
}
