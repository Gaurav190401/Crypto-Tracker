//
//  APIManager.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation
import Combine

class APIManager {
    // Base URLs and endpoints
    private let baseURL = "https://api.coingecko.com/api/v3"
    
    // Endpoints
    private enum Endpoint {
        case coins(currency: String, order: String, perPage: Int, page: Int, sparkline: Bool, priceChangePercentage: String)
        
        var path: String {
            switch self {
                case .coins: return "/coins/markets"
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
            }
        }
    }
    
    // NetworkingManager instance
    private let networkingManager = NetworkingManager()
    
    // MARK: - API Methods
    
    func getCoins(currency: String = "usd",
                  order: String = "market_cap_desc",
                  perPage: Int = 250,
                  page: Int = 1,
                  sparkline: Bool = true,
                  priceChangePercentage: String = "24h") -> AnyPublisher<[CoinModel], Error> {
        
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
    
    // MARK: - Private Methods
    
    private func makeRequest<T: Decodable>(endpoint: Endpoint, decodingType: T.Type) -> AnyPublisher<T, Error> {
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return networkingManager.download(url: url)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let urlError = error as? URLError, urlError.code == .timedOut {
                    return APIError.requestFailed(error)
                } else if let decodingError = error as? DecodingError {
                    return APIError.decodingFailed(decodingError)
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }
}
