//
//  MovieRow.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//
import SwiftUI
import ComposableArchitecture
import Kingfisher

struct MovieRow: View {
    let viewStore: ViewStoreOf<MovieListFeature>
    let movie: Movie
    let isFavoriteList: Bool
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"))
                .placeholder { Color.gray.opacity(0.3) }
                .resizable()
                .aspectRatio(contentMode: .fit) /
                .frame(width: 60, height: 90)
                .clipShape(RoundedRectangle(cornerRadius: 10))

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

            FavoriteButton(isFavorite: viewStore.favoriteMovies.contains { $0.id == movie.id }) {
                viewStore.send(.toggleFavorite(movie))
            }
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
}

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
        }
        .buttonStyle(FavoriteButtonStyle(isFavorite: isFavorite))
        .accessibilityLabel(Text(isFavorite ? "Remove from favorites" : "Add to favorites"))
    }
}

struct FavoriteButtonStyle: ButtonStyle {
    let isFavorite: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.red)
            .font(.title3)
            .padding(8)
            .background(Color.red.opacity(0.1))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isFavorite)
            .hoverEffect(.lift)
    }
}

