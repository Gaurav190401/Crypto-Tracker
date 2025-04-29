//
//  APIManager.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation
import Combine

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    private let networkingManager = NetworkingManager()
    
    private init() {}
    
    // MARK: - Endpoints
    private enum Endpoint {
        case coins(currency: String, order: String, perPage: Int, page: Int, sparkline: Bool, priceChangePercentage: String)
        case coinDetail(id: String)
        case coinMarketChart(id: String, currency: String, days: Int)
        case coinOHLC(id: String, currency: String, days: Int)
        
        var path: String {
            switch self {
                case .coins:
                    return "/coins/markets"
                case .coinDetail(let id):
                    return "/coins/\(id)"
                case .coinMarketChart(let id, _, _):
                    return "/coins/\(id)/market_chart"
                case .coinOHLC(let id, _, _):
                    return "/coins/\(id)/ohlc"
            }
        }
        
        var queryItems: [URLQueryItem] {
            switch self {
                case .coins(let currency, let order, let perPage, let page, let sparkline, let priceChangePercentage):
                    return [
                        URLQueryItem(name: "vs_currency", value: currency),
                        URLQueryItem(name: "order", value: order),
                        URLQueryItem(name: "per_page", value: String(perPage)),
                        URLQueryItem(name: "page", value: String(page)),
                        URLQueryItem(name: "sparkline", value: sparkline ? "true" : "false"),
                        URLQueryItem(name: "price_change_percentage", value: priceChangePercentage)
                    ]
                    
                case .coinDetail:
                    return [
                        URLQueryItem(name: "localization", value: "false"),
                        URLQueryItem(name: "tickers", value: "false"),
                        URLQueryItem(name: "market_data", value: "true"),
                        URLQueryItem(name: "community_data", value: "true"),
                        URLQueryItem(name: "developer_data", value: "true"),
                        URLQueryItem(name: "sparkline", value: "false")
                    ]
                    
                case .coinMarketChart(_, let currency, let days):
                    let items = [
                        URLQueryItem(name: "vs_currency", value: currency),
                        URLQueryItem(name: "days", value: String(days))
                    ]
                    
                    return items
                    
                case .coinOHLC(_, let currency, let days):
                    return [
                        URLQueryItem(name: "vs_currency", value: currency),
                        URLQueryItem(name: "days", value: String(days))
                    ]
            }
        }
    }
    
    // MARK: - API Methods
    
    /// Gets a list of coins with market data
    /// - Parameters:
    ///   - currency: The target currency (default: "usd")
    ///   - order: How to order the results (default: "market_cap_desc")
    ///   - perPage: Number of results per page (default: 250)
    ///   - page: Page number (default: 1)
    ///   - sparkline: Include sparkline data (default: true)
    ///   - priceChangePercentage: Timeframes to include price changes for (default: "24h")
    /// - Returns: Publisher with array of CoinModel or error
    func getCoins(
        currency: String = "usd",
        order: String = "market_cap_desc",
        perPage: Int = 250,
        page: Int = 1,
        sparkline: Bool = true,
        priceChangePercentage: String = "24h"
    ) -> AnyPublisher<[CoinModel], Error> {
        
        let endpoint = Endpoint.coins(
            currency: currency,
            order: order,
            perPage: perPage,
            page: page,
            sparkline: sparkline,
            priceChangePercentage: priceChangePercentage
        )
        
        return makeRequest(endpoint: endpoint, decodingType: [CoinModel].self)
    }
    
    /// Gets detailed information for a specific coin
    /// - Parameters:
    ///   - id: Coin ID (e.g., "bitcoin")
    /// - Returns: Publisher with CoinDetailModel or error
    func getCoinDetail(id: String) -> AnyPublisher<CoinDetailModel, Error> {
        let endpoint = Endpoint.coinDetail(id: id)
        return makeRequest(endpoint: endpoint, decodingType: CoinDetailModel.self)
    }
    
    /// Gets market chart data for a specific coin
    /// - Parameters:
    ///   - id: Coin ID (e.g., "bitcoin")
    ///   - currency: Target currency (default: "usd")
    ///   - days: Number of days of data to return (default: 30)
    /// - Returns: Publisher with MarketChartModel or error
    func getCoinMarketChart(
        id: String,
        currency: String = "usd",
        days: Int = 30
    ) -> AnyPublisher<MarketChartModel, Error> {
        
        let endpoint = Endpoint.coinMarketChart(
            id: id,
            currency: currency,
            days: days
        )
        
        return makeRequest(endpoint: endpoint, decodingType: MarketChartModel.self)
    }
    
    // MARK: - Private Methods
    
    /// Makes an API request and returns decoded data
    /// - Parameters:
    ///   - endpoint: The endpoint to request
    ///   - decodingType: The type to decode the response into
    /// - Returns: Publisher with decoded data or error
    private func makeRequest<T: Decodable>(endpoint: Endpoint, decodingType: T.Type) -> AnyPublisher<T, Error> {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        print("Making request to: \(url.absoluteString)")
        
        return networkingManager.download(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError {
                    if urlError.code == .timedOut {
                        return APIError.requestFailed(urlError)
                    } else {
                        return APIError.requestFailed(urlError)
                    }
                } else if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                    return APIError.decodingFailed(decodingError)
                } else {
                    return APIError.requestFailed(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
