//
//  ChartView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 28/04/25.
//

import Charts
import SwiftUI

struct ChartView: View {
    let chartData: [ChartData]
    let priceChangeColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Price Chart")
                .font(.headline)
            
            Chart {
                ForEach(chartData) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Price", item.price)
                    )
                    .foregroundStyle(priceChangeColor)
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 250)
            .chartYScale(domain: [
                chartData.map({ $0.price }).min() ?? 0,
                chartData.map({ $0.price }).max() ?? 100000
            ])
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(date.asShortDateString())
                        }
                    }
                }
            }
            .transition(.scale.combined(with: .opacity))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
