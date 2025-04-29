//
//  MiniSparklineChartView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 24/04/25.
//

import Charts
import SwiftUI

struct MiniSparklineChartView: View {
    let rawPrices: [Double]
    
    var body: some View {
        let prices = normalize(rawPrices)
        
        Chart {
            ForEach(prices.indices, id: \.self) { index in
                LineMark(
                    x: .value("Index", index),
                    y: .value("Normalized", prices[index])
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 1))
                .foregroundStyle(rawPrices.last ?? 0 >= rawPrices.first ?? 0 ? .green : .red)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 40)
    }
    
    private func normalize(_ prices: [Double]) -> [Double] {
        guard let min = prices.min(), let max = prices.max(), max - min > 0 else {
            return Array(repeating: 0.5, count: prices.count)
        }
        return prices.map { ($0 - min) / (max - min) }
    }
}
