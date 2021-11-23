//
//  SearchMovieInteractor.swift
//  KumuChallenge
//
//  Created by Jc on 11/23/21.
//

import Foundation

final class SearchMovieInteractor: Interactor {
    
    var presenter: Presenter
    
    init(presenter: Presenter) {
        self.presenter = presenter
    }
    
    func fetchMovies() {
        
    }
}
