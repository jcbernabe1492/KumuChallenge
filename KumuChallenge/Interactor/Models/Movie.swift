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

struct Movie: Decodable {
    var wrapperType: WrapperType
    
    var trackId: Int?
    var trackName: String?
    
    var artistName: String
    
    var artworkUrl30: String?
    var artworkUrl60: String?
    var artworkUrl100: String?
    
    var trackPrice: Double?
    var trackRentalPrice: Double?
    var trackHdPrice: Double?
    var trackHdRentalPrice: Double?
    
    var collectionId: Int?
    var collectionName: String?
    var collectionPrice: Double?
    var collectionHdPrice: Double?
    
    var currency: String
    
    var primaryGenreName: String
    
    var trackTimeMillis: Int?
    
    var longDescription: String?
}
