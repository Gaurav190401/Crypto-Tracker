//
//  StatsView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 28/04/25.
//

import SwiftUI

struct StatsView: View {
    
    let coin: CoinDetailModel?
    var formattedPriceChange: String {
        guard let priceChange = coin?.priceChangePercentage24h else { return "0.00%" }
        return "\(priceChange >= 0 ? "+" : "")\(priceChange.asPercentString())"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Statistics")
                .font(.headline)
            
            Group {
                StatisticRow(
                    title: "All Time High",
                    value: "$\(coin?.highestPrice.formatAsCurrency() ?? "0.00")",
                    subtitle: coin?.highDate.prefix(10).description ?? ""
                )
                Divider()
                
                StatisticRow(
                    title: "All Time Low",
                    value: "$\(coin?.lowestPrice.formatAsCurrency() ?? "0.00")",
                    subtitle: coin?.lowDate.prefix(10).description ?? ""
                )
                Divider()
                
                StatisticRow(
                    title: "24h Change",
                    value: formattedPriceChange,
                    subtitle: ""
                )
                Divider()
                
                StatisticRow(
                    title: "7d Change",
                    value: coin?.priceChangePercentage7d.asPercentString() ?? "0.00%",
                    subtitle: ""
                )
                Divider()
                
                StatisticRow(
                    title: "30d Change",
                    value: coin?.priceChangePercentage30d.asPercentString() ?? "0.00%",
                    subtitle: ""
                )
                Divider()
                
                StatisticRow(
                    title: "1y Change",
                    value: coin?.priceChangePercentage1y.asPercentString() ?? "0.00%",
                    subtitle: ""
                )
            }
            
            
            Divider()
            
            Group {
                if let blockTime = coin?.blockTimeInMinutes {
                    StatisticRow(title: "Block Time", value: "\(blockTime) minutes", subtitle: "")
                    Divider()
                }
                
                if let algorithm = coin?.hashingAlgorithm {
                    StatisticRow(title: "Hashing Algorithm", value: algorithm, subtitle: "")
                    Divider()
                }
                
                StatisticRow(
                    title: "Supply",
                    value: "\(coin?.circulatingSupply.formattedWithAbbreviations() ?? "0") / \(coin?.maxSupply.formattedWithAbbreviations() ?? "∞")",
                    subtitle: "Circulating / Max Supply"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    struct StatisticRow: View {
        let title: String
        let value: String
        let subtitle: String
        
        var body: some View {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text(value)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
    }
}
