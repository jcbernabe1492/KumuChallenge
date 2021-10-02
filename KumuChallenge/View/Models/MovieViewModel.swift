//
//  MovieViewModel.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import UIKit

struct MovieViewModel {
    var name: String
    var artworkThumb: UIImage?
    var artwork: UIImage?
    var price: String
    var hdPrice: String
    var genre: String
    
    init(_ movie: Movie) {
        switch movie.wrapperType {
        case .track:
            name = movie.trackName ?? ""
            
            price = "\(movie.currency) \(movie.trackPrice ?? 0.00)"
            hdPrice = "\(movie.currency) \(movie.trackHdPrice ?? 0.00)"
            
            genre = movie.primaryGenreName
            
        case .audioBook:
            name = movie.collectionName ?? ""
            
            price = "\(movie.currency) \(movie.collectionPrice ?? 0.00)"
            hdPrice = "\(movie.currency) \(movie.collectionHdPrice ?? 0.00)"
            
            genre = movie.primaryGenreName
        }
    }
}
