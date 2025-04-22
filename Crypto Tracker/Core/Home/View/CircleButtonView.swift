//
//  CircleButtonView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 22/04/25.
//

import SwiftUI

struct CircleButtonView: View {
    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(.blue)
            .frame(width: 50, height: 50)
            .background(Circle().fill(Color.black))
            .shadow(color: .blue.opacity(0.25), radius: 10)
            .padding()
    }
}
