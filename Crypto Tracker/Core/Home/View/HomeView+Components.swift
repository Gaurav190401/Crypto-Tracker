//
//  HomeView+Components.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import SwiftUI

extension HomeView {
    var header: some View {
        HStack {
            Text("Hello, Investor!!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                withAnimation {
                    vm.listingType.toggle()
                }
            } label: {
                Image(systemName: vm.listingType ? "square.grid.2x2" : "list.bullet")
                    .font(.title3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal)
    }

    var coinsList: some View {
        List(vm.filteredCoins) { coin in
            CoinRowView(coin: coin, showHoldingsColumn: false)
                .listRowInsets(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                .onTapGesture {
                    vm.navigateToDetail(coin)
                }
        }
        .listStyle(PlainListStyle())
        .animation(.bouncy, value: vm.filteredCoins)
    }
    
    var coinsGrid: some View {
        ScrollView {
            LazyVGrid(columns: vm.columns, spacing: 16) {
                ForEach(vm.filteredCoins) { coin in
                    CoinCardView(coin: coin)
                        .onTapGesture {
                            vm.navigateToDetail(coin)
                        }
                }
            }
            .padding()
            .animation(.bouncy, value: vm.filteredCoins)
        }
        .scrollIndicators(.hidden)
    }

    var columnHeaders: some View {
        HStack {
            Text("Coin")
            Spacer()
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.gray)
        .padding(.horizontal)
    }
    
    var loadingView: some View {
        VStack {
            Spacer()
            ProgressView("Loading Coins...")
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
    
    var nodataView: some View {
        VStack {
            Spacer()
            Text("No Coins Found!")
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
