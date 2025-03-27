//
//  MovieListView.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//



import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
    let store: StoreOf<MovieListFeature>
    @State private var showNoConnectionBanner = false
    
    @Namespace private var animationNamespace
    @State private var showFavorites = false
    @State private var showMovieDetails = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    VStack {
                        OfflineBanner(isConnected: viewStore.networkState.isConnected)
                        
                        Picker("Filter", selection: viewStore.binding(
                            get: \.selectedCategory,
                            send: MovieListFeature.Action.filterCategory
                        )) {
                            Text("Upcoming").tag(MovieListFeature.MovieCategory.upcoming)
                            Text("Top Rated").tag(MovieListFeature.MovieCategory.topRated)
                            Text("Now Playing").tag(MovieListFeature.MovieCategory.nowPlaying)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        .padding(.top, 8)
                        
                        MovieListContent(
                            viewStore: viewStore,
                            movies: viewStore.movies,
                            isLoading: viewStore.isLoading,
                            onSelectMovie: { movie in
                                viewStore.send(.movieSelected(movie))
                                showMovieDetails = true
                            },
                            animationNamespace: animationNamespace
                        )
                        .padding(.bottom, 60)
                    }
                    .onAppear {
                        viewStore.send(.network(.startMonitoring))
                    }
                    FavoriteListButton {
                        showFavorites = true
                    }
                    .padding()
                    .accessibilityLabel("Favorite Movies")
                }
                .navigationTitle("Latest Movies")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showFavorites) {
                    FavoriteMoviesView(store: store)
                }
                .sheet(isPresented: $showMovieDetails) {
                    if let selectedMovie = viewStore.selectedMovie {
                        MovieDetailsView(
                            store: Store(
                                initialState: MovieDetailsFeature.State(movie: selectedMovie),
                                reducer: { MovieDetailsFeature() }
                            ),
                            animationNamespace: animationNamespace
                        )
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                    }
                }
            }
            .onAppear {
                if viewStore.movies.isEmpty {
                    viewStore.send(.fetchMovies)
                }
            }
        }
    }
}

struct FavoriteListButton: View {
    let action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "heart.fill")
                        .font(.title2)
                        .padding()
                        .background(.ultraThinMaterial)
                        .foregroundColor(.red)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .hoverEffect(.lift)
                }
            }
        }
    }
}
