//
//  MovieDetailsViewController.swift
//  KumuChallenge
//
//  Created by Jc on 10/13/21.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    private let movieModel: MovieViewModel
    
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var hdPriceLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    private var favoriteBarButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(favoriteTapped))
    
    private var movieId: Int = 0
    
    init?(coder: NSCoder, model: MovieViewModel) {
        movieModel = model
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupValues()
    }
    
    private func setupValues() {
        movieId = movieModel.movieId
        nameLbl.text = movieModel.name
        priceLbl.text = "\(movieModel.price)"
        hdPriceLbl.text = "\(movieModel.hdPrice)"
        descriptionLbl.text = movieModel.description
    }
    
    private func setupFavoriteButton() {
        if let nav = navigationController {
            nav.navigationItem.setRightBarButton(favoriteBarButton, animated: true)
        }
    }
    
    @objc private func favoriteTapped() {
        if movieModel.isFavorite {
            favoriteBarButton.image = UIImage(systemName: "star")
        } else {
            favoriteBarButton.image = UIImage(systemName: "star.fill")
        }
    }
}
