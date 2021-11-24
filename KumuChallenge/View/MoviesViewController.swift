//
//  MoviesViewController.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/24/21.
//

import UIKit
import SnapKit

class MoviesViewController: UIViewController {
    
    /// Reference to movies table.
    private lazy var moviesTable = UITableView(frame: view.bounds)
    
    /// Reference to favorite bar button item.
    private lazy var favoriteListBarItem = UIBarButtonItem(title: "Show Faves",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(favoritesTapped))
    
    /// Movies view model list.
    private var movies: [MovieViewModel] = []
    
    /// List of searched movies.
    ///
    /// Used a different array of view models for searching to retain original list after exiting search.
    private var searchedMovies: [MovieViewModel] = []
    
    /// Reference to movie presenter.
    ///
    /// Presenter processes data before giving it to this view controller.
    private lazy var presenter = MoviePresenter(view: self)
    
    /// Reference to movie list interactor that fetches list of movies.
    ///
    /// Interactor initiates processing of data that will later be received by this view via the presenter.
    private lazy var movieListInteractor = MovieListInteractor(presenter: presenter)
    
    /// Reference to favorite movie interactor that fetches list of favorite movies.
    ///
    /// Interactor initiates processing of data that will later be received by this view via the presenter.
    private lazy var favoriteMovieInteractor = FavoriteMovieInteractor(presenter: presenter)
    
    /// Flag if favorites list is currently active or not.
    private var isFavoritesShowing = false
    
    /// Flag if search is active or not.
    private var isSearching = false
    
    /// Reference to search controller.
    private let searchController = UISearchController(searchResultsController: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        if movies.count == 0 {
            movieListInteractor.fetchMovies()
        }
    }
    
    // MARK: UI Setup
    
    /// Setup user interface.
    private func setupInterface() {
        view.backgroundColor = bgColor
        
        setupNavigationBar()
        setupTable()
        setupSearchController()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = bgColor
        
        navigationItem.rightBarButtonItem = favoriteListBarItem
    }
    
    private func setupTable() {
        view.addSubview(moviesTable)
        moviesTable.snp.makeConstraints { make in
            make.leadingMargin.equalTo(view)
            make.trailingMargin.equalTo(view)
            make.topMargin.equalTo(view)
            make.bottomMargin.equalTo(view)
        }
        
        moviesTable.backgroundColor = bgColor
        moviesTable.delegate = self
        moviesTable.dataSource = self
        moviesTable.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        moviesTable.separatorStyle = .none
        moviesTable.rowHeight = UITableView.automaticDimension
        moviesTable.estimatedRowHeight = 150
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.backgroundColor = bgColor
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    // MARK: Favorites Action
    
    @objc func favoritesTapped() {
        if isFavoritesShowing {
            // Hide favorites
            movieListInteractor.fetchMovies()
            favoriteListBarItem.title = "Show Faves"
        } else {
            // Show favorites
            favoriteMovieInteractor.fetchFavoriteMovies()
            favoriteListBarItem.title = "Hide Faves"
        }
        isFavoritesShowing = !isFavoritesShowing
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
        if isSearching {
            searchedMovies = movieModels
        } else {
            movies = movieModels
        }
        
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
        return (isSearching ? searchedMovies : movies).count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        cell.selectionStyle = .none
        
        cell.setMovieData((isSearching ? searchedMovies : movies)[indexPath.row])
        cell.favoriteAction = { id, isFavorite in
            self.favoriteMovieInteractor.setFavoriteMovie(id: id, isFavorite: isFavorite)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = MovieDetailsViewController(model: movies[indexPath.row])
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
            searchedMovies = movies
        } else {
            // Added delay to give buffer when user is typing slow.
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                self.movieListInteractor.searchMovies(searchString: strippedString)
            }
        }
    }
}
   
