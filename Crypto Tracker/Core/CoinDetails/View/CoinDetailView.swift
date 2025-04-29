//
//  CoinDetailView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 25/04/25.
//

import SwiftUI
import Charts

struct CoinDetailView: View {
    @ObservedObject var viewModel = CoinDetailViewModel()
    let id: String
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerView
                        
                        priceSection
                        
                        if viewModel.showChart {
                            ChartView(chartData: viewModel.chartData, priceChangeColor: viewModel.priceChangeColor)
                            timeframeSelector
                        }
                        
                        StatsView(coin: viewModel.coin)
                        
                        if let description = viewModel.coin?.descriptionText, !description.isEmpty {
                            descriptionSection(description: description)
                        }
                        
                        LinkView(coin: viewModel.coin)
                        
                        Spacer()
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                if viewModel.isLoading {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    LoadingView()
                }
            }
            .onAppear {
                viewModel.loadData(coinId: id)
            }
            .onChange(of: viewModel.chartData) { _, _ in
                if !viewModel.chartData.isEmpty {
                    withAnimation(.bouncy) {
                        viewModel.showChart = true
                    }
                }
            }
            .navigationTitle(viewModel.coin?.name ?? "")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolBarItemView
                }
            }
            .blur(radius: viewModel.isLoading ? 3 : 0)
        }
    }
}
