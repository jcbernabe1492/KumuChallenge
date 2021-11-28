//
//  View.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import Foundation

protocol View: AnyObject {
    
    /// Show movies in user interface.
    /// - Parameter movieModels: Movie view models that will contain data to be presented in the UI.
    func showMovies(_ movieModels: [MovieViewModel])
}
