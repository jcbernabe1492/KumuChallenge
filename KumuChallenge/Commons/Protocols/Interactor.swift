//
//  Interactor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

protocol Interactor {
    
    /// Presenter instance that will receive data from interactor for processing.
    var presenter: Presenter { get set }
}

protocol MovieFetcher: Interactor {
    
    /// Fetch movies
    func fetchMovies()
    
    /// Search movies.
    /// - Parameter searchString: Optional string parameter for searching movies.
    func searchMovies(searchString: String)
}

protocol FavoriteMovieFetcher: Interactor {
    
    /// Fetch favorite movies.
    func fetchFavoriteMovies()
    
    /// Set movie as favorite.
    /// - Parameters:
    ///   - id: Movie unique identifier that will be used to flag "favorite" value
    ///   - isFavorite: If to be flagged as favorite or not.
    func setFavoriteMovie(id: Int, isFavorite: Bool)
}
