//
//  MovieDetailsFeature.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import ComposableArchitecture
import SwiftUI

struct MovieDetailsFeature: Reducer {
    struct State: Equatable { 
        var movie: Movie
        var trailerURL: URL?
        
    }

    enum Action {
        case fetchTrailer
        case trailerLoaded(Result<URL, APIError>)
    }

    @Dependency(\.movieService) var movieService
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchTrailer:
            let movieID = state.movie.id
            return .run { send in
                let result = await movieService.fetchTrailer(for: movieID)
                await send(.trailerLoaded(result))
            }
        case .trailerLoaded(let result):
            switch result {
            case .success(let url):
                state.trailerURL = url
            case .failure:
                state.trailerURL = nil
            }
            return .none
        }
    }


}


