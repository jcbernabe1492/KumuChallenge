//
//  Presenter.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

protocol Presenter {
    
    /// View object that will receive data from presenter.
    var viewController: View { get set }
    
    /// Process Movies from Interactor before passing to View.
    /// - Parameter movies: Array of movies retreived from interactor.
    func processMovies(_ movies: [Movie])
}
