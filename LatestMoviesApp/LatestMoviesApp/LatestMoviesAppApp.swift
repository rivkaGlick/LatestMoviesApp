//
//  LatestMoviesAppApp.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher


@main
struct LatestMoviesAppApp: App {
    
    let store = Store(initialState: MovieListFeature.State()) {
            MovieListFeature()
        }
    
    
    
    init() {
           let cache = ImageCache.default
           cache.memoryStorage.config.expiration = .seconds(86400) 
           cache.diskStorage.config.expiration = .days(1)
        
        KeychainManager.save(key: "API_KEY", value: "fe422d845b15742622d0865fc5a4963d")

       }

        var body: some Scene {
            WindowGroup {
                MovieListView(store: store)
            }
        }
}
