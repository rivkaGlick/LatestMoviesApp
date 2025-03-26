//
//  MovieListContent.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//
import SwiftUI
import ComposableArchitecture

struct MovieListContent: View {
    var viewStore: ViewStoreOf<MovieListFeature>
    let movies: [Movie]
    let isLoading: Bool
    let onSelectMovie: (Movie) -> Void
    let animationNamespace: Namespace.ID

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(movies, id: \.id) { movie in
                    MovieRow(viewStore: viewStore, movie: movie, isFavoriteList: false) {
                        onSelectMovie(movie)
                    }
                    .id(movie.id)
                    .matchedGeometryEffect(id: movie.id, in: animationNamespace)
                    
                    if movie == viewStore.movies.last {
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    let frame = geometry.frame(in: .global)
                                    let screenHeight = UIScreen.main.bounds.height
                                    
                                    if frame.minY < screenHeight * 1.2 {
                                        viewStore.send(.loadNextPage)
                                    }
                                }
                        }
                        .frame(height: 1) 
                    }
                }

                if isLoading {
                    ProgressView("Loading movies...")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
        }
    }
}
