//
//  Interactor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

protocol Interactor {
    func fetchMoviesList()
    func setFavoriteMovie(id: Int, isFavorite: Bool)
}
