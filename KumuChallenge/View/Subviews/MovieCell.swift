//
//  MovieCell.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import UIKit

class MovieCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var hdPriceLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!

    func setMovieData(_ movie: MovieViewModel) {
        nameLbl.text = movie.name
        priceLbl.text = "\(movie.price)"
        hdPriceLbl.text = "\(movie.hdPrice)"
    }
    
    @IBAction func favoriteTapped(_ button: UIButton) {
        button.isSelected = !button.isSelected
    }
}
