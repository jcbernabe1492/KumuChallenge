//
//  Interactor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

/// Interactor
protocol Interactor {
    
    /// Presenter instance that will receive data from interactor for processing.
    var presenter: Presenter { get set }
    
    /// Fetch movies agnostic of source.
    func fetchMovies()
}
