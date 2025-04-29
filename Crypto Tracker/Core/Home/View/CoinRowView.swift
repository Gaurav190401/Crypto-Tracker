//
//  CoinRowView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import SwiftUI
import Kingfisher

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            Spacer()
            if let price = coin.sparklineIn7D?.price {
                MiniSparklineChartView(rawPrices: price)
                    .frame(width: 60)
            }
            rightColumn
        }
        .font(.subheadline)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 8) {
            KFImage(URL(string: coin.image))
                .resizable()
                .placeholder {
                    Circle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 35, height: 35)
                }
                .scaledToFit()
                .frame(width: 35, height: 35)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
        }
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.blue)
            HStack {
                Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                    .font(.subheadline)
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.green :
                        Color.red
                    )
                
                Image(systemName: (coin.priceChangePercentage24H ?? 0) >= 0 ? "arrowtriangle.up.fill": "arrowtriangle.down.fill")
                    .font(.caption2)
                    .foregroundColor(
                        (coin.priceChangePercentage24H ?? 0) >= 0 ?
                        Color.green :
                        Color.red
                    )
            }
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
