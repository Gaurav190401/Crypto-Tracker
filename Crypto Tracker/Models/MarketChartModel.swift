//
//  MarketChartModel.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import Foundation

struct MarketChartModel: Codable {
    let prices: [[Double]]
    let marketCaps: [[Double]]
    let totalVolumes: [[Double]]
    
    enum CodingKeys: String, CodingKey {
        case prices
        case marketCaps = "market_caps"
        case totalVolumes = "total_volumes"
    }
    
    /// Converts price data to ChartData array
    func toPriceChartData() -> [ChartData] {
        return prices.map { dataPoint in
            // First element is timestamp in milliseconds, second is price
            let date = Date(timeIntervalSince1970: dataPoint[0] / 1000)
            let price = dataPoint[1]
            return ChartData(date: date, price: price)
        }
    }
}
