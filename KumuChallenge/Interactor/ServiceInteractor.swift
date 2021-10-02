//
//  ServiceInteractor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation

final class ServiceInteractor: Interactor {
    
    private var moviePresenter: Presenter
    
    init(presenter: Presenter) {
        moviePresenter = presenter
    }
    
    func fetchMoviesList() {
        ServiceWorker.request(ofType: MovieList.self,
                              baseURL: "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all",
                              endpoint: "") { result in
            switch result {
            case .success(let movieList):
                dump("movieList \(movieList)")
                self.moviePresenter.processMovies(movieList.movies)
                
            case .failure(let error):
                dump("error \(error)")
            }
        }
    }
}
