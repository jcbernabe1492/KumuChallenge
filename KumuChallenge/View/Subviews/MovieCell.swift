//
//  MovieCell.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    // MARK:
    
    var favoriteAction: ((Int, Bool)->())? = nil
    
    // MARK: IBOutlets
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var hdPriceLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!

    private var movieId: Int = 0
    
    func setMovieData(_ movie: MovieViewModel) {
        movieId = movie.movieId
        nameLbl.text = movie.name
        priceLbl.text = "\(movie.price)"
        hdPriceLbl.text = "\(movie.hdPrice)"
        favoriteBtn.isSelected = movie.isFavorite
    }
    
    @IBAction func favoriteTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
        favoriteAction?(movieId, button.isSelected)
    }
}
