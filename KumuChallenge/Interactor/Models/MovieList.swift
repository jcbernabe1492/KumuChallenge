//
//  MovieList.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

/// Fetch movies result model.
struct MovieList: Decodable {
    
    /// Number of movies received in API response.
    var resultCount: Int
    
    /// Array of movie objects.
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}
