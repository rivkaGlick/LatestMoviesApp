//
//  MovieListFeature.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//
import Foundation
import ComposableArchitecture
import Network

struct MovieListFeature: Reducer {
    struct State: Equatable {
        var selectedCategory: MovieCategory = .nowPlaying
        var movies: [Movie] = []
        var favoriteMovies: [Movie] = []
        var isLoading: Bool = false
        var errorMessage: String?
        var selectedMovie: Movie? = nil
        var currentPage: Int = 1
        var totalPages: Int = 1
        var lastMovieID: Int? = nil
        var networkState: NetworkFeature.State = .init()
        
        
    }
    
    enum Action {
        case fetchMovies
        case moviesLoadedNew(Result<([Movie], Int), APIError>)
        case movieSelected(Movie?)
        case movieDetails(MovieDetailsFeature.Action)
        case filterCategory(MovieCategory)
        case toggleFavorite(Movie)
        case loadNextPage
        case updateLastMovieID(Int)
        case network(NetworkFeature.Action)
        
        
    }
    
    enum MovieCategory: String, Equatable, CaseIterable {
        case upcoming = "upcoming"
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
    }
    
    
    @Dependency(\.movieService) var movieService
    
    var body: some ReducerOf<Self> {
        Scope(state: \.networkState, action: /Action.network) {
            NetworkFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .fetchMovies:
                guard state.networkState.isConnected else {
                    return .none
                }
                
                state.isLoading = true
                return .run { [category = state.selectedCategory, currentPage = state.currentPage] send in
                    let result = await MovieService().fetchMovies(category: category, page: currentPage)
                    await send(.moviesLoadedNew(result))
                }
                
            case .moviesLoadedNew(let result):
                state.isLoading = false
                switch result {
                case .success(let (movies, totalPages)):
                    state.movies.append(contentsOf: movies)
                    state.currentPage += 1
                    state.totalPages = totalPages
                case .failure:
                    break
                }
                return .none
                
            case .movieSelected(let movie):
                state.selectedMovie = movie
                return .none
                
            case .movieDetails:
                return .none
                
            case .filterCategory(let category):
                state.selectedCategory = category
                state.currentPage = 1
                state.totalPages = 1
                state.movies = []
                return .send(.fetchMovies)
                
            case .toggleFavorite(let movie):
                if state.favoriteMovies.contains(where: { $0.id == movie.id }) {
                    state.favoriteMovies.removeAll { $0.id == movie.id }
                } else {
                    state.favoriteMovies.append(movie)
                }
                return .none
                
            case .loadNextPage:
                guard state.currentPage <= state.totalPages else { return .none }
                return .send(.fetchMovies)
                
            case .updateLastMovieID(let movieID):
                state.lastMovieID = movieID
                return .none
                
            case .network(let networkAction):
                switch networkAction {
                case .connectionChanged(let isConnected):
                    state.networkState.isConnected = isConnected
                    print("🔄 חיבור רשת השתנה ברשימת סרטים: \(isConnected)")
                    
                    // ✅ אם החיבור חזר, נטען את הסרטים מחדש
                    if isConnected {
                        return .send(.fetchMovies)
                    }
                    
                case .startMonitoring:
                    return .run { send in
                        await send(.network(.startMonitoring))
                    }
                }
                return .none
            }
        }
    }
    
    //    func reduce(into state: inout State, action: Action) -> Effect<Action> {
    //
    //        switch action {
    //        case .fetchMovies:
    //            state.isLoading = true
    //            return .run { [category = state.selectedCategory, currentPage = state.currentPage] send in
    //                let result = await MovieService().fetchMovies(category: category, page: currentPage)
    //                await send(.moviesLoadedNew(result))
    //            }
    //        case .moviesLoadedNew(let result):
    //            state.isLoading = false
    //            switch result {
    //            case .success(let (movies, totalPages)):
    //                state.movies.append(contentsOf: movies)
    //                state.currentPage += 1
    //                state.totalPages = totalPages
    //            case .failure:
    //                break
    //            }
    //            return .none
    //        case .movieSelected(let movie):
    //            print("Reducer: movieSelected - Selected movie: \(movie?.title ?? "None")")
    //            state.selectedMovie = movie
    //            print("Reducer: After update - Selected movie in state: \(state.selectedMovie?.title ?? "None")")
    //            return .none
    //
    //        case .movieDetails:
    //            return .none
    //
    //        case .filterCategory(let category):
    //            state.selectedCategory = category
    //            state.currentPage = 1
    //            state.totalPages = 1
    //            state.movies = []
    //            return .send(.fetchMovies)
    //
    //        case .toggleFavorite(let movie):
    //            if state.favoriteMovies.contains(where: { $0.id == movie.id }) {
    //                state.favoriteMovies.removeAll { $0.id == movie.id }
    //            } else {
    //                state.favoriteMovies.append(movie)
    //            }
    //            return .none
    //        case .loadNextPage:
    //            guard state.currentPage <= state.totalPages else { return .none }
    //            return .send(.fetchMovies)
    //        case .updateLastMovieID(let movieID):
    //            state.lastMovieID = movieID
    //            return .none
    //
    //
    //        }
    //    }
    
}

