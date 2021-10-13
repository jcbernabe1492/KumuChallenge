//
//  MovieViewModel.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import UIKit

struct MovieViewModel {
    var movieId: Int
    var name: String
    var description: String
    var artworkThumb: UIImage?
    var artwork: UIImage?
    var price: String
    var hdPrice: String
    var genre: String
    var isFavorite: Bool
    
    init(_ movie: Movie) {
        movieId = movie.trackId ?? movie.collectionId ?? 0
        
        switch movie.wrapperType {
        case .track:
            name = movie.trackName ?? ""
            
            price = "\(movie.currency) \(movie.trackPrice ?? 0.00)"
            hdPrice = "\(movie.currency) \(movie.trackHdPrice ?? 0.00)"
            
        case .audioBook:
            name = movie.collectionName ?? ""
            
            price = "\(movie.currency) \(movie.collectionPrice ?? 0.00)"
            hdPrice = "\(movie.currency) \(movie.collectionHdPrice ?? 0.00)"
        }
        
        description = movie.longDescription ?? ""
        genre = movie.primaryGenreName
        isFavorite = movie.isFavorite
    }
}
