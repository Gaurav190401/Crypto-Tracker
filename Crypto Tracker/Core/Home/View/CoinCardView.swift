//
//  CoinCardView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import SwiftUI
import Kingfisher

struct CoinCardView: View {
    let coin: CoinModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                KFImage(URL(string: coin.image))
                    .resizable()
                    .placeholder {
                        Circle()
                            .fill(Color.gray.opacity(0.25))
                            .frame(width: 40, height: 40)
                    }
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                Spacer()
                Text(coin.symbol.uppercased())
                    .font(.subheadline)
                    .lineLimit(1)
                    .foregroundColor(.gray)
            }

            Text(coin.name)
                .font(.headline)
                .lineLimit(1)
           
            Text("$\(coin.currentPrice, specifier: "%.2f")")
                .font(.title3)
                .fontWeight(.bold)
                .lineLimit(1)
                .foregroundColor(.blue)
            
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
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.25), radius: 5, x: 0, y: 2)
    }
}
