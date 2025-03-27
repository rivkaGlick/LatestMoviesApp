//
//  MovieListView.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import SwiftUI
import ComposableArchitecture



import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
    let store: StoreOf<MovieListFeature>
    
    @Namespace private var animationNamespace
    @State private var showFavorites = false
    @State private var showMovieDetails = false
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                ZStack {
                    VStack {
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
                if viewStore.movies.isEmpty { // מונע רינדור מיותר
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
                        .background(.ultraThinMaterial) // ✅ תואם ל-HIG
                        .foregroundColor(.red)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                        .hoverEffect(.lift)
                }
            }
        }
    }
}


//

//struct MovieListView: View {
//    let store: StoreOf<MovieListFeature>
//    //    @StateObject private var networkMonitor = NetworkMonitor()
//    @State private var showNoConnectionBanner = false
//
//    @Namespace private var animationNamespace
//
//    @State private var showMovieDetails = false
//    @State private var showFavorites = false
//
//    var body: some View {
//        WithViewStore(store, observe: { $0 }) { viewStore in
//
//                NavigationStack {
//                    ZStack {
//                        VStack {
////                            OfflineBanner(isConnected: viewStore.networkState.isConnected)
//
//                            Picker("Filter", selection: viewStore.binding(
//                                get: \.selectedCategory,
//                                send: MovieListFeature.Action.filterCategory
//                            )) {
//                                Text("Upcoming").tag(MovieListFeature.MovieCategory.upcoming)
//                                Text("Top Rated").tag(MovieListFeature.MovieCategory.topRated)
//                                Text("Now Playing").tag(MovieListFeature.MovieCategory.nowPlaying)
//                            }
//                            .pickerStyle(.segmented)
//                            .padding(.horizontal)
//                            .padding(.top, 8)
//
//                            MovieListContent(
//                                viewStore: viewStore,
//                                movies: viewStore.movies,
//                                isLoading: viewStore.isLoading,
//                                onSelectMovie: { movie in
//                                    viewStore.send(.movieSelected(movie))
//                                    showMovieDetails = true
//                                },
//                                animationNamespace: animationNamespace
//                            )
//                            .padding(.bottom, 60)
//                        }
////                        .onAppear {
////                            viewStore.send(.network(.startMonitoring)) //  הפעלת מעקב אחרי מצב הרשת
////                        }
//                        VStack {
//                            Spacer()
//                            HStack {
//                                Spacer()
//                                Button(action: { showFavorites = true }) {
//                                    Image(systemName: "heart.fill")
//                                        .font(.title2)
//                                        .padding()
//                                        .background(Color.red)
//                                        .foregroundColor(.white)
//                                        .clipShape(Circle())
//                                        .shadow(radius: 4)
//                                }
//                                .padding()
//                                .accessibilityLabel("Favorite Movies")
//                            }
//                        }
//                    }
//
//                    .navigationTitle("Latest Movies")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .sheet(isPresented: $showFavorites) {
//                        FavoriteMoviesView(store: store)
//                    }
//                    .sheet(isPresented: $showMovieDetails) {
//                        if let selectedMovie = viewStore.selectedMovie {
//                            MovieDetailsView(
//                                store: Store(
//                                    initialState: MovieDetailsFeature.State(movie: selectedMovie),
//                                    reducer: { MovieDetailsFeature() }
//                                ),
//                                animationNamespace: animationNamespace
//                            )
//                            .presentationDetents([.medium, .large])
//                            .presentationDragIndicator(.visible)
//                        }
//                    }
//                }
//                .task {
//                    viewStore.send(.fetchMovies)
//                }
//            }
//    }
//}
