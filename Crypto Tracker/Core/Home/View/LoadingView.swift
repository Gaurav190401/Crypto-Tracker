//
//  LoadingView.swift
//  Crypto Tracker
//
//  Created by Gaurav Harkhani on 28/04/25.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            LottieView(animation: .named("crypto-loader-animation"))
                .looping()
            Spacer()
        }
    }
}
