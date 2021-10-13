//
//  Movie.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/27/21.
//

import Foundation

enum WrapperType: String, Decodable {
    case track
    case audioBook = "audiobook"
}

class Movie: NSObject, NSCoding, Decodable {
    
    var wrapperType: WrapperType = .track
    
    var trackId: Int?
    var trackName: String?
    
    var artistName: String = ""
    
    var artworkUrl100: String?
    
    var trackPrice: Double?
    var trackRentalPrice: Double?
    var trackHdPrice: Double?
    var trackHdRentalPrice: Double?
    
    var collectionId: Int?
    var collectionName: String?
    var collectionPrice: Double?
    var collectionHdPrice: Double?
    
    var currency: String = ""
    
    var primaryGenreName: String = ""
    
    var trackTimeMillis: Int?
    
    var longDescription: String?
    
    var isFavorite = false
    
    override init() {}
    required init?(coder: NSCoder) {}
    
    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        
        case artistName
        
        case artworkUrl100
        
        case trackPrice
        case trackRentalPrice
        case trackHdPrice
        case trackHdRentalPrice
        
        case collectionId
        case collectionName
        case collectionPrice
        case collectionHdPrice
        
        case currency
        case primaryGenreName
        case trackTimeMillis
        case longDescription
        
        case isFavorite
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(trackId, forKey: "trackId")
        coder.encode(trackName, forKey: "trackName")
        
        coder.encode(artistName, forKey: "artistName")
        
        coder.encode(artworkUrl100, forKey: "artworkUrl100")
        
        coder.encode(trackPrice, forKey: "artworkUrl100")
        coder.encode(trackRentalPrice, forKey: "artworkUrl100")
        coder.encode(trackHdPrice, forKey: "trackHdPrice")
        coder.encode(trackHdRentalPrice, forKey: "trackHdRentalPrice")
        
        coder.encode(collectionId, forKey: "collectionId")
        coder.encode(collectionName, forKey: "collectionName")
        coder.encode(collectionPrice, forKey: "collectionPrice")
        coder.encode(collectionHdPrice, forKey: "collectionHdPrice")
        
        coder.encode(currency, forKey: "currency")
        coder.encode(primaryGenreName, forKey: "primaryGenreName")
        coder.encode(trackTimeMillis, forKey: "trackTimeMillis")
        coder.encode(longDescription, forKey: "longDescription")
        
        coder.encode(isFavorite, forKey: "isFavorite")
    }
    
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            trackId = try values.decode(Int.self, forKey: .trackId)
            trackName = try values.decode(String.self, forKey: .trackName)
            
            artistName = try values.decode(String.self, forKey: .artistName)
            
            artworkUrl100 = try values.decode(String.self, forKey: .artworkUrl100)
            
            trackPrice = try values.decode(Double.self, forKey: .trackPrice)
            trackRentalPrice = try values.decode(Double.self, forKey: .trackRentalPrice)
            trackHdPrice = try values.decode(Double.self, forKey: .trackHdPrice)
            trackHdRentalPrice = try values.decode(Double.self, forKey: .trackHdRentalPrice)
            
            collectionId = try values.decode(Int.self, forKey: .collectionId)
            collectionName = try values.decode(String.self, forKey: .collectionName)
            collectionPrice = try values.decode(Double.self, forKey: .collectionPrice)
            collectionHdPrice = try values.decode(Double.self, forKey: .collectionHdPrice)
            
            currency = try values.decode(String.self, forKey: .currency)
            primaryGenreName = try values.decode(String.self, forKey: .primaryGenreName)
            trackTimeMillis = try values.decode(Int.self, forKey: .trackTimeMillis)
            longDescription = try values.decode(String.self, forKey: .longDescription)
            
            isFavorite = try values.decode(Bool.self, forKey: .isFavorite)
        } catch {
            // Do nothing for now.
        }
    }
}
