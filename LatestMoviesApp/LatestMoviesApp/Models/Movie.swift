//
//  Movie.swift
//  LatestMoviesApp
//
//  Created by rivki glick on 24/03/2025.
//
import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
    


}

