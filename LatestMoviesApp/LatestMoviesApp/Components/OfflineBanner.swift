//
//  Untitled.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 25/03/2025.
//

import SwiftUI
struct OfflineBanner: View {
    let isConnected: Bool

    var body: some View {
        if !isConnected {
            Text("🔴 No Internet Connection")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .font(.body)
                .cornerRadius(8)
                .shadow(radius: 5)
                .transition(.slide)
                .padding(.top)
                .animation(.easeInOut, value: isConnected)
        }
    }
}
