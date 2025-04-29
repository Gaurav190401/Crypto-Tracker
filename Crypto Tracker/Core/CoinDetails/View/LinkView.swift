//
//  LinkView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 28/04/25.
//

import SwiftUI

struct LinkView: View {
    
    let coin: CoinDetailModel?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Links")
                .font(.headline)
            
            if let websiteURL = coin?.websiteURL, !websiteURL.isEmpty {
                Link(destination: URL(string: websiteURL)!) {
                    LinkRow(title: "Website", icon: "globe")
                }
            }
            
            if let whitepaper = coin?.links.whitepaper, !whitepaper.isEmpty {
                Link(destination: URL(string: whitepaper)!) {
                    LinkRow(title: "Whitepaper", icon: "doc.text")
                }
            }
            
            if let redditURL = coin?.redditURL, !redditURL.isEmpty {
                Link(destination: URL(string: redditURL)!) {
                    LinkRow(title: "Reddit", icon: "message.fill")
                }
            }
            
            if let twitter = coin?.links.twitterScreenName, !twitter.isEmpty {
                Link(destination: URL(string: "https://twitter.com/\(twitter)")!) {
                    LinkRow(title: "Twitter", icon: "bubble.left.fill")
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
        )
    }
    
    struct LinkRow: View {
        let title: String
        let icon: String
        
        var body: some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
        }
    }
}
