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
            rightColumn
        }
        .font(.subheadline)
    }
}

extension CoinRowView {
    
    private var leftColumn: some View {
        HStack(spacing: 0) {
            KFImage(URL(string: coin.image))
                .resizable()
                .placeholder {
                    Circle()
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: 30, height: 30)
                }
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.blue)
        }
        .padding(.leading, 8)
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
        .padding(.trailing, 8)
    }
}
