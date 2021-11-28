//
//  MovieCell.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/28/21.
//

import UIKit
import SnapKit

class MovieCell: UITableViewCell {
    
    var favoriteAction: ((Int, Bool)->())? = nil
    
    // MARK: IBOutlets
    
    private let holderView = UIView(frame: .zero)
    
    private let thumbnail = UIImageView(frame: .zero)
    private let nameLbl = UILabel(frame: .zero)
    private let priceLbl = UILabel(frame: .zero)
    private let genreLbl = UILabel(frame: .zero)
    private let favoriteBtn = UIButton(type: .custom)

    private var movieId: Int = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnail.image = nil
    }
    
    private func setupInterface() {
        backgroundColor = UIColor.clear
        
        contentView.addSubview(holderView)
        holderView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: 30, left: 12, bottom: 8, right: 8))
        }
        holderView.backgroundColor = UIColor(hexString: "1C1B37")
        holderView.layer.shadowColor = UIColor.black.cgColor
        holderView.layer.shadowOpacity = 0.7
        holderView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        holderView.layer.shadowRadius = 2
        holderView.layer.cornerRadius = 4
        
        holderView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(holderView).inset(120)
            make.trailingMargin.equalTo(holderView).inset(40)
            make.topMargin.equalTo(holderView).inset(12)
        }
        nameLbl.textColor = UIColor.white
        nameLbl.numberOfLines = 0
        nameLbl.font = UIFont(name: "Futura-Bold", size: 15)
        
        holderView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLbl)
            make.trailingMargin.equalTo(nameLbl)
            make.top.equalTo(nameLbl.snp_bottomMargin).offset(16)
            make.height.equalTo(12)
        }
        priceLbl.textColor = UIColor.lightGray
        priceLbl.font = UIFont(name: "Futura", size: 11)
        
        holderView.addSubview(genreLbl)
        genreLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLbl)
            make.trailingMargin.equalTo(nameLbl)
            make.top.equalTo(priceLbl.snp_bottomMargin).offset(16)
            make.bottomMargin.equalTo(holderView).inset(12).priority(999)
            make.height.equalTo(12)
        }
        genreLbl.textColor = UIColor.gray
        genreLbl.font = UIFont(name: "Futura", size: 11)
        
        holderView.addSubview(favoriteBtn)
        favoriteBtn.snp.makeConstraints { make in
            make.topMargin.equalTo(holderView).inset(12)
            make.trailingMargin.equalTo(holderView).inset(12)
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        favoriteBtn.setImage(UIImage(named: "fave-off"), for: .normal)
        favoriteBtn.setImage(UIImage(named: "fave-on"), for: .selected)
        favoriteBtn.imageView?.tintColor = UIColor.orange
        favoriteBtn.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)
        
        contentView.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { make in
            make.leadingMargin.equalTo(contentView).inset(8)
            make.topMargin.equalTo(contentView).inset(8)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        thumbnail.contentMode = .scaleAspectFit
    }
    
    func setMovieData(_ movie: MovieViewModel, isSearch: Bool) {
        movieId = movie.movieId
        nameLbl.text = movie.name
        priceLbl.text = movie.price
        genreLbl.text = movie.genre
        if isSearch {
            favoriteBtn.isHidden = true
        }
        favoriteBtn.isSelected = movie.isFavorite
        if let url = movie.artworkURL {
            ImageCache.shared.loadImage(from: url) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.thumbnail.image = image
                    }
                    
                case .failure(_):
                    break
                }
            }
        }
    }
    
    @objc func favoriteTapped() {
        favoriteBtn.isSelected = !favoriteBtn.isSelected
        favoriteAction?(movieId, favoriteBtn.isSelected)
    }
}
