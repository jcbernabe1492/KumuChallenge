//
//  MovieDetailsViewController.swift
//  KumuChallenge
//
//  Created by Jc on 10/13/21.
//

import UIKit
import SnapKit

/// Class to show full movie details.
class MovieDetailsViewController: UIViewController {
    
    private let movieModel: MovieViewModel
    
    private let holderView = UIView(frame: .zero)
    
    private let thumbnail = UIImageView(frame: .zero)
    private let nameLbl = UILabel(frame: .zero)
    private let priceLbl = UILabel(frame: .zero)
    private let hdPriceLbl = UILabel(frame: .zero)
    private let genreLbl = UILabel(frame: .zero)
    private let descriptionLbl = UILabel(frame: .zero)
    
    init(model: MovieViewModel) {
        movieModel = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
        setupValues()
    }
    
    private func setupInterface() {
        view.backgroundColor = bgColor
        
        view.addSubview(holderView)
        holderView.snp.makeConstraints { make in
            make.topMargin.equalTo(view).inset(50)
            make.leadingMargin.equalTo(view).inset(8)
            make.trailingMargin.equalTo(view).inset(8)
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
        
        holderView.addSubview(hdPriceLbl)
        hdPriceLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLbl)
            make.trailingMargin.equalTo(nameLbl)
            make.top.equalTo(priceLbl.snp_bottomMargin).offset(16)
            make.height.equalTo(12)
        }
        hdPriceLbl.textColor = UIColor.lightGray
        hdPriceLbl.font = UIFont(name: "Futura", size: 11)
        
        holderView.addSubview(genreLbl)
        genreLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLbl)
            make.trailingMargin.equalTo(nameLbl)
            make.top.equalTo(hdPriceLbl.snp_bottomMargin).offset(16)
            make.height.equalTo(12)
        }
        genreLbl.textColor = UIColor.gray
        genreLbl.font = UIFont(name: "Futura", size: 11)
        
        holderView.addSubview(descriptionLbl)
        descriptionLbl.snp.makeConstraints { make in
            make.leadingMargin.equalTo(nameLbl)
            make.trailingMargin.equalTo(nameLbl)
            make.top.equalTo(genreLbl.snp_bottomMargin).offset(16)
            make.bottomMargin.equalTo(holderView).inset(12).priority(999)
        }
        descriptionLbl.textColor = UIColor.lightGray
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = UIFont(name: "Futura", size: 11)
        
        view.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { make in
            make.top.equalTo(view).inset(8)
            make.leading.equalTo(view).inset(25)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        thumbnail.contentMode = .scaleAspectFit
    }
    
    private func setupValues() {
        nameLbl.text = movieModel.name
        priceLbl.text = movieModel.price
        hdPriceLbl.text = "in HD: \(movieModel.hdPrice)"
        genreLbl.text = movieModel.genre
        descriptionLbl.text = movieModel.description
        if let url = movieModel.artworkURL {
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
}
