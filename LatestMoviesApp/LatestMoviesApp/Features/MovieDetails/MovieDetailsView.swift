//
//  MovieDetailsView.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import SwiftUI
import Kingfisher
import ComposableArchitecture

struct MovieDetailsView: View {
    let store: StoreOf<MovieDetailsFeature>
    let animationNamespace: Namespace.ID

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    MoviePosterView(posterPath: viewStore.movie.posterPath, id: viewStore.movie.id, namespace: animationNamespace)

                    MovieTitleView(title: viewStore.movie.title)

                    MovieInfoView(releaseDate: viewStore.movie.releaseDate, rating: viewStore.movie.rating)

                    MovieDescriptionView(overview: viewStore.movie.overview)

                    if let trailerURL = viewStore.trailerURL {
                        PlayTrailerButton(trailerURL: trailerURL)
                    } else {
                        PlaceholderText(text: "No trailer available")
                    }

                    Spacer()
                }
                .padding()
            }
            .background(Color(.systemBackground)) // תמיכה ב-Light/Dark Mode
            .navigationTitle("Movie Details")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { viewStore.send(.fetchTrailer) }
        }
    }
}

// MARK: - Subviews

struct MoviePosterView: View {
    let posterPath: String?
    let id: Int
    let namespace: Namespace.ID

    var body: some View {
        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"))
            .placeholder { Color.gray.opacity(0.3) }
            .resizable()
            .scaledToFit()
            .matchedGeometryEffect(id: id, in: namespace)
            .frame(maxWidth: .infinity, maxHeight: 300)
            .cornerRadius(16)
            .shadow(radius: 8)
            .accessibilityLabel("Movie Poster")
    }
}

struct MovieTitleView: View {
    let title: String?

    var body: some View {
        Text(title ?? "Unknown Title")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.horizontal)
            .accessibilityLabel("Movie title: \(title ?? "Unknown")")
    }
}

struct MovieInfoView: View {
    let releaseDate: String?
    let rating: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let releaseDate = releaseDate {
                Text("Release Year: \(releaseDate.prefix(4))")
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Release Year: \(releaseDate.prefix(4))")
            }

            if let rating = rating {
                HStack {
                    Text("Rating: \(String(format: "%.1f", rating))/10")
                        .font(.headline)
                        .foregroundColor(.yellow)
                        .accessibilityLabel("Rating: \(String(format: "%.1f", rating)) out of 10")
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct MovieDescriptionView: View {
    let overview: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let overview = overview, !overview.isEmpty {
                Text("Description:")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(overview)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .truncationMode(.tail)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Movie description: \(overview)")
            } else {
                PlaceholderText(text: "No description available.")
            }
        }
        .padding(.horizontal)
    }
}

struct PlayTrailerButton: View {
    let trailerURL: URL

    var body: some View {
        Button(action: { openTrailer(url: trailerURL) }) {
            HStack {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)

                Text("Watch Trailer")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            .shadow(radius: 4)
        }
        .buttonStyle(.plain)
        .padding(.top, 10)
        .scaleEffect(1.0)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.2)) {
                // אפקט קליק קטן
            }
        }
        .accessibilityLabel("Watch movie trailer")
    }

    private func openTrailer(url: URL) {
        UIApplication.shared.open(url)
    }
}


struct PlaceholderText: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.body)
            .foregroundColor(.gray)
            .padding(.horizontal)
            .accessibilityLabel(text)
    }
}




