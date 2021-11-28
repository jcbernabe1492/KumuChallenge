//
//  Configurator.swift
//  KumuChallenge
//
//  Created by Jc on 11/25/21.
//

import UIKit

final class Configurator {
    
    func setupViewController() -> UIViewController {
        let presenter = MoviePresenter()
        let interactor = MovieListInteractor()
        let movieVC = MoviesViewController()
        interactor.presenter = presenter
        presenter.viewController = movieVC
        movieVC.movieListInteractor = interactor
        movieVC.favoriteMovieInteractor.presenter = presenter
        return movieVC
    }
}
