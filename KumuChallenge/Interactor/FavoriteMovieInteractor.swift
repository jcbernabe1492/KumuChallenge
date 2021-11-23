//
//  FavoriteMovieInteractor.swift
//  KumuChallenge
//
//  Created by Jc on 11/23/21.
//

import Foundation

final class FavoriteMovieInteractor: Interactor {
    
    var presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
        
    func fetchMovies() {
        let faveMovies = CoreDataWorker.shared.fetchMovies(isFavorites: true)
        presenter.processMovies(faveMovies)
    }
    
    func setFavoriteMovie(id: Int, isFavorite: Bool) {
        CoreDataWorker.shared.updateFavoriteMovie(trackId: id, isFavorite: isFavorite)
    }
}

