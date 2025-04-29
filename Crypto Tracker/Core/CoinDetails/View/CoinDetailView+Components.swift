//
//  CoinDetailView+Components.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 29/04/25.
//

import SwiftUI

extension CoinDetailView {
    
    var toolBarItemView: some View {
        HStack {
            Text(viewModel.coin?.symbol.uppercased() ?? "")
                .font(.headline)
                .foregroundColor(.secondary)
            
            if let imageUrl = viewModel.coin?.image.small {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            }
        }
    }
     
    var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(viewModel.formattedPrice)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(viewModel.formattedPriceChange)
                        .font(.headline)
                        .foregroundColor(viewModel.priceChangeColor)
                }
            }
            
            Spacer()
            
            if let marketCapRank = viewModel.coin?.marketCapRank {
                VStack(spacing: 4) {
                    Text("Rank")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("#\(marketCapRank)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.1))
                )
            }
        }
    }
    
    var priceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Market Cap")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedMarketCap)
                        .font(.headline)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Volume (24h)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedVolume)
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    var timeframeSelector: some View {
        HStack(spacing: 15) {
            ForEach(CoinDetailViewModel.Timeframe.allCases, id: \.self) { timeframe in
                Button(action: {
                    viewModel.fetchChartData(timeframe: timeframe)
                }) {
                    Text(timeframe.rawValue)
                        .font(.caption)
                        .fontWeight(viewModel.selectedTimeframe == timeframe ? .bold : .regular)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(viewModel.selectedTimeframe == timeframe ? viewModel.priceChangeColor : Color.gray.opacity(0.1))
                        )
                        .foregroundColor(viewModel.selectedTimeframe == timeframe ? .white : .primary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 8)
    }
    
    func descriptionSection(description: String) -> some View {
        return VStack(alignment: .leading, spacing: 12) {
            Text("About \(viewModel.coin?.name ?? "Bitcoin")")
                .font(.headline)
            
            Text(description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil))
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
