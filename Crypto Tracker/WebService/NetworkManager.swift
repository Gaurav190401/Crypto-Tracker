//
//  NetworkManager.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation
import Combine

class NetworkingManager {
    private var cancellables = Set<AnyCancellable>()
    
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL, statusCode: Int)
        case unknown
        
        var errorDescription: String? {
            switch self {
                case .badURLResponse(url: let url, statusCode: let statusCode):
                    return "Bad response from URL: \(url), status code: \(statusCode)"
                case .unknown:
                    return "Unknown error occurred"
            }
        }
    }
    
    func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { [weak self] (output) -> Data in
                guard let self = self else { throw NetworkingError.unknown }
                return try self.handleURLResponse(output: output, url: url)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else {
            throw NetworkingError.unknown
        }
        
        switch response.statusCode {
            case 200...299:
                return output.data
            case 429:
                throw NetworkingError.badURLResponse(url: url, statusCode: response.statusCode) // Rate limit
            case 400...499:
                throw NetworkingError.badURLResponse(url: url, statusCode: response.statusCode) // Client error
            case 500...599:
                throw NetworkingError.badURLResponse(url: url, statusCode: response.statusCode) // Server error
            default:
                throw NetworkingError.badURLResponse(url: url, statusCode: response.statusCode)
        }
    }
}
