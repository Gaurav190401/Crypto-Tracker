//
//  APIError.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case serverError(Int)
    case rateLimitExceeded
    
    var description: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .requestFailed(let error): return "Request failed: \(error.localizedDescription)"
        case .invalidResponse: return "Invalid response from server"
        case .decodingFailed(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .serverError(let code): return "Server error with code: \(code)"
        case .rateLimitExceeded: return "Rate limit exceeded. Please try again later."
        }
    }
}
