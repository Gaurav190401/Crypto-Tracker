//
//  ChartData.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import Foundation

struct ChartData: Identifiable, Equatable {
    let id = UUID()
    let date: Date
    let price: Double
    
    init(date: Date, price: Double) {
        self.date = date
        self.price = price
    }
    
    static func mockChartData() -> [ChartData] {
        let today = Date()
        let calendar = Calendar.current
        
        var chartData = [ChartData]()
        
        // Generate 30 days of mock data
        for day in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { continue }
            
            // Base price of Bitcoin (around $69,000 with some randomness)
            let basePrice = 69000.0
            let randomFactor = Double.random(in: 0.92...1.08)
            let price = basePrice * randomFactor
            
            chartData.append(ChartData(date: date, price: price))
        }
        
        return chartData.reversed()
    }
}
