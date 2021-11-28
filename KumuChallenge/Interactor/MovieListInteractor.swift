//
//  MovieInteractor.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation

final class MovieListInteractor: MovieFetcher {
    
    var requestWorker: RequestWorker
     
    var presenter: Presenter?
    
    init(worker: RequestWorker = RequestWorker()) {
        requestWorker = worker
    }
    
    func fetchMovies() {
        requestWorker.request(ofType: MovieList.self,
                              baseURL: "https://itunes.apple.com/search?term=star&amp;country=au&amp;media=movie&amp;all",
                              endpoint: "") { result in
            
            let dispatchGrp = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "PersistingMoviesQueue")
            
            switch result {
            case .success(let movieList):
                for movie in movieList.movies {
                    dispatchGrp.enter()
                    print("[jc] enter")
                    CoreDataWorker.shared.saveMovie(movie) { result in
                        
                        switch result {
                        case .success:
                            break
                            
                        case .failure(let error):
                            dump("Core data saving error \(error)")
                        }
                        dispatchGrp.leave()
                        print("[jc] leave")
                    }
                }
                
            case .failure(let error):
                dump("error \(error)")
            }
            
            dispatchGrp.notify(queue: dispatchQueue) {
                print("[jc] notify")
                let movies = CoreDataWorker.shared.fetchMovies()
                self.presenter?.processMovies(movies)
            }
        }
    }
    
    func searchMovies(searchString: String) { 
        requestWorker.request(ofType: MovieList.self,
                              baseURL: "https://itunes.apple.com/search?term=\(searchString)&amp;country=au&amp;media=movie&amp;all",
                              endpoint: "") { result in
            switch result {
            case .success(let movieList):
                self.presenter?.processMovies(movieList.movies)
                
            case .failure(let error):
                dump("error \(error)")
            }
        }
    }
}
