//
//  MoviePresenter.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation

final class MoviePresenter: Presenter {
    
    private var viewController: View
    
    init(view: View) {
        viewController = view
    }
    
    func processMovies(_ movies: [Movie]) {
        var models: [MovieViewModel] = []
        movies.forEach { movie in
            models.append(MovieViewModel(movie))
        }
        viewController.showMovies(models)
    }s
}
