//
//  HomeViewModel.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import Foundation
import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var allCoins: [CoinModel] = []
    @Published var filteredCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var selectedCoin: CoinModel? = nil
    @Published var showDetailView = false
    @Published var listingType = true
    
    // MARK: - Private Properties
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    private let apiManager = APIManager()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        fetchAllCoins()
        addSearchSubscriber()
    }
    
    // MARK: - Fetch Coins
    private func fetchAllCoins() {
        isLoading = true
        apiManager.getCoins()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    print("Error fetching coins: \(error)")
                }
            } receiveValue: { [weak self] coins in
                self?.isLoading = false
                self?.allCoins = coins
                self?.filteredCoins = coins
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search Filtering
    private func addSearchSubscriber() {
        $searchText
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .combineLatest($allCoins)
            .map { (text, coins) in
                guard !text.isEmpty else { return coins }
                let lowercasedText = text.lowercased()
                return coins.filter {
                    $0.name.lowercased().contains(lowercasedText) ||
                    $0.symbol.lowercased().contains(lowercasedText) ||
                    $0.id.lowercased().contains(lowercasedText)
                }
            }
            .assign(to: &$filteredCoins)
    }
    
    func navigateToDetail(_ coin: CoinModel) {
        selectedCoin = coin
        showDetailView = true
    }
}
