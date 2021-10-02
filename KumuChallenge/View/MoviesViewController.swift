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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if movies.count == 0 {
            let si = ServiceInteractor(presenter: MoviePresenter(view: self))
            si.fetchMoviesList()
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as! MovieCell
        cell.setMovieData(movies[indexPath.row])
        return cell
    }
}

