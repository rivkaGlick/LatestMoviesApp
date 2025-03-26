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
    let isFavoriteList: Bool // ✅ האם זו רשימת מועדפים?
    let action: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"))
                .placeholder { Color.gray.opacity(0.3) }
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 90) // ✅ גודל אחיד
                .clipShape(RoundedRectangle(cornerRadius: 10))
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
                Image(systemName: viewStore.favoriteMovies.contains(where: { $0.id == movie.id }) ? "heart.fill" : "heart")
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
        .onTapGesture { action() }
    }
}
