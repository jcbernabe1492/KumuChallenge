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
    private var filteredMovies: [MovieViewModel] = []
    private var favoriteMovies: [MovieViewModel] = []
    
    private lazy var presenter = MoviePresenter(view: self)
    private lazy var movieListInteractor = MovieListInteractor(presenter: presenter)
    private lazy var favoriteMovieInteractor = FavoriteMovieInteractor(presenter: presenter)
    private lazy var searchMovieInteractor = SearchMovieInteractor(presenter: presenter)
    
    private var isFavoritesShowing = false
    private var isSearching = false
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if movies.count == 0 {
            movieListInteractor.fetchMovies()
        }
    }
    
    @IBAction func favoritesTapped(_ sender: UIBarButtonItem) {
        if isFavoritesShowing {
            // Hide favorites
            movieListInteractor.fetchMovies()
            sender.title = "Show Faves"
        } else {
            // Show favorites
            favoriteMovieInteractor.fetchMovies()
            sender.title = "Hide Faves"
        }
        isFavoritesShowing = !isFavoritesShowing
    }
    
    // MARK: Search
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    // MARK: Keyboard
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange(_ :)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc private func keyboardFrameWillChange(_ notification: Notification) {
        let keyboardBeginValue = notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let keyboardEndValue = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardFrame = view.convert(keyboardEndValue, from: nil)
        
        let isShowing = keyboardBeginValue.origin.y > keyboardEndValue.origin.y
        
        let height = isShowing ? keyboardFrame.height - view.safeAreaInsets.bottom : 0
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        moviesTable.contentInset = insets
        moviesTable.scrollIndicatorInsets = insets
    }
}

// MARK: - View Protocol

extension MoviesViewController: View {
    func showMovies(_ movieModels: [MovieViewModel]) {
        movies = movieModels
        DispatchQueue.main.async {
            self.moviesTable.reloadData()
        }
    }
}

// MARK: - UITableView Delegate & Data Source

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isSearching ? filteredMovies : movies).count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        
        cell.selectionStyle = .none
        
        cell.setMovieData((isSearching ? filteredMovies : movies)[indexPath.row])
        cell.favoriteAction = { id, isFavorite in
            self.favoriteMovieInteractor.setFavoriteMovie(id: id, isFavorite: isFavorite)
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

// MARK: - UISearch

extension MoviesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if strippedString.count == 0  {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter{ $0.name.localizedCaseInsensitiveContains(strippedString) }
        }
        
        moviesTable.reloadData()
    }
}
   
