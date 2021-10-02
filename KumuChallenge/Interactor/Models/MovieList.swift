//
//  MovieList.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

struct MovieList: Decodable {
    var resultCount: Int
    var movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}
