//
//  MovieService.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//

import ComposableArchitecture
import Foundation

struct MovieService {
    private let apiKey = "fe422d845b15742622d0865fc5a4963d" 
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies(category: MovieListFeature.MovieCategory, page: Int) async -> Result<([Movie], Int), APIError> {
        let urlString = "\(baseURL)/movie/\(category.rawValue)?api_key=\(apiKey)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return .failure(.networkError)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            return .success((response.results, response.totalPages))
        } catch {
            return .failure(.networkError)
        }
    }
    
    func fetchTrailer(for movieID: Int) async -> Result<URL, APIError> {
        let trailerURLString = "\(baseURL)/movie/\(movieID)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: trailerURLString) else {
            return .failure(.networkError)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try JSONDecoder().decode(TrailerResponse.self, from: data)
            
            if let trailer = decodedResponse.results.first, !trailer.key.isEmpty {
                let trailerURL = URL(string: "https://www.youtube.com/watch?v=\(trailer.key)")!
                return .success(trailerURL)
            } else {
                return .failure(.unknown)
            }
        } catch {
            return .failure(.networkError)
        }
    }

}

struct TrailerResponse: Decodable {
    let results: [Trailer]
}

struct Trailer: Decodable {
    let key: String  
}

struct MovieResponse: Codable {
    let page: Int
    let totalPages: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}

enum APIError: Error, Equatable {
    case networkError
    case unknown
}

