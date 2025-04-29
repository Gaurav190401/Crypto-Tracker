//
//  CoinDetailsViewModel.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import Foundation
import Combine
import SwiftUI

class CoinDetailViewModel: ObservableObject {
    @Published var coin: CoinDetailModel?
    @Published var chartData: [ChartData] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedTimeframe: Timeframe = .month
    @Published var showChart = false
    
    private let apiManager = APIManager.shared
    private var cancellables = Set<AnyCancellable>()

    enum Timeframe: String, CaseIterable {
        case day = "24h"
        case week = "7d"
        case month = "30d"
        case threeMonths = "90d"
        case year = "1y"

        var days: Int {
            switch self {
            case .day: return 1
            case .week: return 7
            case .month: return 30
            case .threeMonths: return 90
            case .year: return 365
            }
        }
    }

    func loadData(coinId: String) {
        isLoading = true
        errorMessage = nil

        apiManager.getCoinDetail(id: coinId)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] coin in
                self?.coin = coin
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self?.fetchChartData(timeframe: self?.selectedTimeframe ?? .month)
                }
            }
            .store(in: &cancellables)
    }

    func fetchChartData(timeframe: Timeframe) {
        selectedTimeframe = timeframe
        guard let coinId = coin?.id else { return }

        apiManager.getCoinMarketChart(id: coinId, currency: "usd", days: timeframe.days)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] marketChart in
                self?.chartData = marketChart.prices.map {
                    ChartData(date: Date(timeIntervalSince1970: $0[0] / 1000),
                              price: $0[1])
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - UI Helpers
    var formattedPrice: String {
        guard let currentPrice = coin?.currentPrice else { return "$0.00" }
        return "$\(currentPrice.formatAsCurrency())"
    }

    var formattedMarketCap: String {
        guard let marketCap = coin?.marketCap else { return "$0.00" }
        return "$\(marketCap.formattedWithAbbreviations())"
    }

    var formattedVolume: String {
        guard let volume = coin?.volume else { return "$0.00" }
        return "$\(volume.formattedWithAbbreviations())"
    }

    var priceChangeColor: Color {
        guard let priceChange = coin?.priceChangePercentage24h else { return .gray }
        return priceChange >= 0 ? .green : .red
    }

    var formattedPriceChange: String {
        guard let priceChange = coin?.priceChangePercentage24h else { return "0.00%" }
        return "\(priceChange >= 0 ? "+" : "")\(priceChange.asPercentString())"
    }
}
