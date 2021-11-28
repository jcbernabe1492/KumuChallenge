//
//  MoviePresenter.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation

final class MoviePresenter: Presenter {
    
    weak var viewController: View?
   
    func processMovies(_ movies: [Movie]) {
        var models: [MovieViewModel] = []
        movies.forEach { movie in
            models.append(MovieViewModel(movie))
        }
        viewController?.showMovies(models)
    }
}
