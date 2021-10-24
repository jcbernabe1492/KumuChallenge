//
//  Interactor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

/// Interactor 
protocol Interactor {
    func fetchMoviesList()
    func fetchFavoriteMoviesList()
    func setFavoriteMovie(id: Int, isFavorite: Bool)
}
