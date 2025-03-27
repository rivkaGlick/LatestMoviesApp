//
//  MovieDetailsView.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct MovieDetailsView: View {
    let store: StoreOf<MovieDetailsFeature>
    let animationNamespace: Namespace.ID

    var body: some View {
        WithViewStore(store, observe: \.self) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(viewStore.movie.posterPath ?? "")"))
                        .placeholder {
                            Color.gray.opacity(0.5)
                        }
                        .resizable()
                        .scaledToFit()
                        .matchedGeometryEffect(id: viewStore.movie.id, in: animationNamespace)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(12)
                        .shadow(radius: 10)

                    Text(viewStore.movie.title ?? "")
                        .font(.largeTitle)
                        .bold()
                        .padding(.horizontal)
                        .foregroundColor(.primary) 

                    if let releaseDate = viewStore.movie.releaseDate {
                        Text("Release Year: \(releaseDate.prefix(4))")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    if let rating = viewStore.movie.rating {
                        HStack {
                            Text("Rating: \(String(format: "%.1f", rating))/10")
                                .font(.headline)
                                .foregroundColor(.yellow)
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        .padding(.horizontal)
                    }

                    if let overview = viewStore.movie.overview, !overview.isEmpty {
                        Text("Description:")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal)

                        Text(overview)
                            .font(.body)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .truncationMode(.tail)
                            .foregroundColor(.secondary)
                            
                    } else {
                        Text("No description available.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    if let trailerURL = viewStore.trailerURL {
                        Button(action: {
                            openTrailer(url: trailerURL)
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                Text("Play Trailer")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                    } else {
                        Text("No trailer available")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Movie Details")
            .navigationBarTitleDisplayMode(.inline) 
            .onAppear {
                viewStore.send(.fetchTrailer) 
            }
        }
    }

    // פונקציה לפתיחת הטריילר
    private func openTrailer(url: URL) {
        if let trailerView = URL(string: url.absoluteString) {
            UIApplication.shared.open(trailerView)
        }
    }
}



