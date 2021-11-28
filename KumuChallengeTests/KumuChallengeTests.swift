//
//  KumuChallengeTests.swift
//  KumuChallengeTests
//
//  Created by Jc Bernabe on 9/24/21.
//

import XCTest
@testable import KumuChallenge

class KumuChallengeTests: XCTestCase {
    
    private var movieVC: MoviesViewController!
    private var interactor: MockMovieListInteractor!
    private var presenter: MoviePresenter!
    
    override func setUp() {
        interactor = MockMovieListInteractor(worker: RequestWorker(urlSession: MockURLSession()))
        presenter = MoviePresenter()
        movieVC = MoviesViewController()
        interactor.presenter = presenter
        presenter.viewController = movieVC
        movieVC.movieListInteractor = interactor
        movieVC.favoriteMovieInteractor.presenter = presenter
        movieVC.loadViewIfNeeded()
    }
    
    override func tearDown() {
        movieVC = nil
        interactor = nil
        presenter = nil
    }
    
    func testFetchMovies() {
        // given: movies are to be loaded
        
        // when: fetchMovies is called
        movieVC.movieListInteractor?.fetchMovies()
        
        let expectation = expectation(description: "moviesVC movies should not be empty")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            // then: movieVC movies count should not be 0
            XCTAssertEqual(self.movieVC.movies.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testSearchMovies() {
        // given: movies are to be searched
        movieVC.isSearching = true
        
        // when: searchMovies is called
        movieVC.movieListInteractor?.searchMovies(searchString: "star")
        
        let expectation = expectation(description: "moviesVC movies should not be empty")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            // then: movieVC movies count should not be 0
            XCTAssertEqual(self.movieVC.searchedMovies.count, 1)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testMovieDetails() {
        // given: movie object
        let testTitle = "testTitle"
        let movie = Movie()
        movie.trackName = testTitle
        let movieModel = MovieViewModel(movie)
        
        // when: movie details is presented
        let movieDetails = MovieDetailsViewController(model: movieModel)
        movieDetails.loadViewIfNeeded()
        movieVC.navigationController?.pushViewController(movieDetails, animated: false)
        
        // then: movie details view controller should contain movie information
        XCTAssertEqual(testTitle, movieDetails.nameLbl.text)
    }
    
    func testFavorites() {
        // given: that movie list is loaded then a movie is set as favorite
        //movieVC.movieListInteractor?.fetchMovies()
        
        let testMovieId = 111
        let movie = Movie()
        movie.trackId = testMovieId
        movie.isFavorite = true
        CoreDataWorker.shared.saveMovie(movie)
        
        // when: favorites list is to be shown
        movieVC.favoritesTapped()
        
        let expectation = expectation(description: "moviesVC movies should show favorite movies")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            // then: favorite movies should be in data source
            XCTAssert(self.movieVC.movies.contains(where: { $0.movieId == 111 }))
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
}

fileprivate class MockMovieListInteractor: MovieFetcher {
    var requestWorker: RequestWorker
    
    var presenter: Presenter?
    
    init(worker: RequestWorker) {
        requestWorker = worker
    }
    
    func fetchMovies() {
        requestWorker.request(ofType: Movie.self, baseURL: "testURL", endpoint: "testEndpoint") { result in
            switch result {
            case .failure(_):
                break
            case .success(_):
                self.presenter?.processMovies([Movie()])
            }
        }
    }
    
    func searchMovies(searchString: String) {
        self.presenter?.processMovies([Movie()])
    }
}

fileprivate class MockURLSession: URLSessionProtocol {
    
    var dataTask = MockURLSessionDataTask()
    var data: Data?
    var error: Error?
    
    func httpURLResponse(request: URLRequest) -> URLResponse? {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        generateSampleData()
        completionHandler(data, httpURLResponse(request: request), error)
        return dataTask
    }
    
    private func generateSampleData() {
        if let path = Bundle.main.path(forResource: "sampleData", ofType: "json") {
            do {
                data = try Data(contentsOf: URL(fileURLWithPath: path), options: [])
            } catch {}
        }
    }
}

fileprivate class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
}


