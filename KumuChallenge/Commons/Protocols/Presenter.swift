//
//  Presenter.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

protocol Presenter {
    
    /// Process Movies from Interactor before passing to View.
    /// - Parameter movies: Array of movies retreived from interactor.
    func processMovies(_ movies: [Movie])
}
