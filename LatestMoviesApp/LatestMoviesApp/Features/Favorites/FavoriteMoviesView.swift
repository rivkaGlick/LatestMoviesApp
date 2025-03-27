//
//  FavoriteMoviesView.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//
import SwiftUI
import ComposableArchitecture
import Kingfisher

struct FavoriteMoviesView: View {
    let store: StoreOf<MovieListFeature>
    
    @Namespace private var animationNamespace
    @State private var selectedMovie: Movie?

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack {
                    if viewStore.favoriteMovies.isEmpty {
                        emptyStateView
                    } else {
                        List {
                            ForEach(viewStore.favoriteMovies) { movie in
                                MovieRow(viewStore: viewStore, movie: movie, isFavoriteList: true) {
                                    selectedMovie = movie
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    let movie = viewStore.favoriteMovies[index]
                                    viewStore.send(.toggleFavorite(movie))
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .animation(.easeInOut, value: viewStore.favoriteMovies)
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.inline) 
                .sheet(item: $selectedMovie) { movie in
                    MovieDetailsView(
                        store: Store(
                            initialState: MovieDetailsFeature.State(movie: movie),
                            reducer: { MovieDetailsFeature() }
                        ),
                        animationNamespace: animationNamespace
                    )
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

private var emptyStateView: some View {
    VStack(spacing: 12) {
        Image(systemName: "heart.slash.fill")
            .font(.system(size: 60))
            .foregroundColor(.gray)
            .padding(.bottom, 8)
        
        Text("No Favorites Yet")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.primary)

        Text("Browse movies and tap the heart to add them to your favorites.")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
    .padding()
}

private struct FavoriteMovieRow: View {
    let movie: Movie
    let viewStore: ViewStore<MovieListFeature.State, MovieListFeature.Action>
    let onSelectMovie: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"))
                .placeholder { Color.gray.opacity(0.3) }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 90)
                .cornerRadius(10)
                .clipped()

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title ?? "Unknown Title")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(movie.releaseDate?.prefix(4) ?? "N/A")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                viewStore.send(.toggleFavorite(movie))
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.title3)
                    .padding(8)
                    .background(Color.red.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { onSelectMovie() }
    }
}
