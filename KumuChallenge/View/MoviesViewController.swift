//
//  MoviesViewController.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/24/21.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesTable: UITableView!
    
    private var movies: [MovieViewModel] = []
    private var favoriteMovies: [MovieViewModel] = []
    
    private lazy var interactor = MovieInteractor(presenter: MoviePresenter(view: self))
    
    private var isFavoritesShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if movies.count == 0 {
            interactor.fetchMoviesList()
        }
    }
    
    @IBAction func favoritesTapped(_ sender: UIBarButtonItem) {
        if isFavoritesShowing {
            // Hide favorites
            interactor.fetchMoviesList()
            sender.title = "Show Faves"
        } else {
            // Show favorites
            interactor.fetchFavoriteMoviesList()
            sender.title = "Hide Faves"
        }
        isFavoritesShowing = !isFavoritesShowing
    }
}

extension MoviesViewController: View {
    func showMovies(_ movieModels: [MovieViewModel]) {
        movies = movieModels
        DispatchQueue.main.async {
            self.moviesTable.reloadData()
        }
    }
}

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        cell.selectionStyle = .none
        
        cell.setMovieData(movies[indexPath.row])
        cell.favoriteAction = { id, isFavorite in
            print("\(id)-\(isFavorite)")
            self.interactor.setFavoriteMovie(id: id, isFavorite: isFavorite)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "MovieDetailsViewController") { coder -> MovieDetailsViewController? in
            MovieDetailsViewController(coder: coder, model: self.movies[indexPath.row])
        }
        navigationController?.pushViewController(detailsVc, animated: true)
    }
}

