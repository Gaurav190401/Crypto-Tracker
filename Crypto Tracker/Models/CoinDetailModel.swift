//
//  CoinDetailModel.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import Foundation

struct CoinDetailModel: Codable, Identifiable {
    let id, symbol, name: String
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: [String: String]?
    let links: Links
    let image: ImageLinks
    let marketData: MarketData
    let lastUpdated: String
    let marketCapRank: Int?
    let categories: [String]?
    let genesisDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case description, links, image
        case marketData = "market_data"
        case lastUpdated = "last_updated"
        case marketCapRank = "market_cap_rank"
        case categories
        case genesisDate = "genesis_date"
    }
    
    // Computed properties for easy access
    var currentPrice: Double {
        marketData.currentPrice["usd"] ?? 0
    }
    
    var marketCap: Double {
        marketData.marketCap["usd"] ?? 0
    }
    
    var rank: Int {
        marketCapRank ?? 0
    }
    
    var volume: Double {
        marketData.totalVolume["usd"] ?? 0
    }
    
    var priceChangePercentage24h: Double {
        marketData.priceChangePercentage24h ?? 0
    }
    
    var priceChangePercentage7d: Double {
        marketData.priceChangePercentage7d ?? 0
    }
    
    var priceChangePercentage14d: Double {
        marketData.priceChangePercentage14d ?? 0
    }
    
    var priceChangePercentage30d: Double {
        marketData.priceChangePercentage30d ?? 0
    }
    
    var priceChangePercentage60d: Double {
        marketData.priceChangePercentage60d ?? 0
    }
    
    var priceChangePercentage1y: Double {
        marketData.priceChangePercentage1y ?? 0
    }
    
    var highestPrice: Double {
        marketData.ath["usd"] ?? 0
    }
    
    var lowestPrice: Double {
        marketData.atl["usd"] ?? 0
    }
    
    var highDate: String {
        marketData.athDate["usd"] ?? ""
    }
    
    var lowDate: String {
        marketData.atlDate["usd"] ?? ""
    }
    
    var descriptionText: String {
        description?["en"] ?? "No description available."
    }
    
    var websiteURL: String {
        links.homepage.first { !$0.isEmpty } ?? ""
    }
    
    var redditURL: String {
        links.subredditURL ?? ""
    }
    
    var circulatingSupply: Double {
        marketData.circulatingSupply ?? 0
    }
    
    var totalSupply: Double {
        marketData.totalSupply ?? 0
    }
    
    var maxSupply: Double {
        marketData.maxSupply ?? 0
    }
}

struct ImageLinks: Codable {
    let thumb, small, large: String
}

struct Links: Codable {
    let homepage: [String]
    let subredditURL: String?
    let whitepaper: String?
    let blockchainSite: [String]?
    let officialForumURL: [String]?
    let twitterScreenName: String?
    let facebookUsername: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
        case whitepaper
        case blockchainSite = "blockchain_site"
        case officialForumURL = "official_forum_url"
        case twitterScreenName = "twitter_screen_name"
        case facebookUsername = "facebook_username"
    }
}

struct MarketData: Codable {
    let currentPrice: [String: Double]
    let ath, atl: [String: Double]
    let athDate, atlDate: [String: String]
    let marketCap: [String: Double]
    let marketCapRank: Int
    let totalVolume: [String: Double]
    let priceChangePercentage24h, priceChangePercentage7d, priceChangePercentage14d, priceChangePercentage30d, priceChangePercentage60d, priceChangePercentage1y: Double?
    let circulatingSupply, totalSupply, maxSupply: Double?
    
    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case ath, atl
        case athDate = "ath_date"
        case atlDate = "atl_date"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case priceChangePercentage7d = "price_change_percentage_7d"
        case priceChangePercentage14d = "price_change_percentage_14d"
        case priceChangePercentage30d = "price_change_percentage_30d"
        case priceChangePercentage60d = "price_change_percentage_60d"
        case priceChangePercentage1y = "price_change_percentage_1y"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
    }
}
