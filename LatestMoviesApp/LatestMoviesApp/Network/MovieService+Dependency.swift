//
//  MovieService+Dependency.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import ComposableArchitecture

private enum MovieServiceKey: DependencyKey {
    static let liveValue = MovieService()
}

extension DependencyValues {
    var movieService: MovieService {
        get { self[MovieServiceKey.self] }
        set { self[MovieServiceKey.self] = newValue }
    }
}
