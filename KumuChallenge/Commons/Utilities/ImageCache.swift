//
//  ImageCache.swift
//  KumuChallenge
//
//  Created by Jc on 10/14/21.
//

import UIKit

/// Fetch images with caching capability.
final class ImageCache {
    
    /// Shared instance variable.
    static let shared = ImageCache()
    
    typealias imageResult = (Result<UIImage, Error>) -> Void
    
    /// Load image from url string then apply caching once successfully downloaded.
    /// - Parameters:
    ///   - urlString: URL string of image to be downloaded.
    ///   - completion: Completion handler once image is downloaded or loaded from cache.
    func loadImage(from urlString: String, completion: @escaping imageResult) {
        guard let urlRequest = RequestUtils.generateURLRequest(baseURL: urlString,
                                                                endpoint: "",
                                                                method: .GET) else {
            completion(.failure(RequestError.invalidRequest))
            return
        }
            
        let urlCache = URLCache.shared
        
        if let cachedData = urlCache.cachedResponse(for: urlRequest)?.data,
           let image = UIImage(data: cachedData) {
            completion(.success(image))
        } else {
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let _error = error {
                    completion(.failure(_error))
                }

                guard let _response = response as? HTTPURLResponse else {
                    completion(.failure(RequestError.invalidResponse))
                    return
                }

                if RequestUtils.isSuccessfulResponse(code: _response.statusCode) {
                    if let _data = data,
                       let image = UIImage(data: _data) {
                        let cachedResponse = CachedURLResponse(response: _response, data: _data)
                        urlCache.storeCachedResponse(cachedResponse, for: urlRequest)
                        completion(.success(image))
                    }
                } else {
                    // Failed
                    completion(.failure(RequestError.errorResponse))
                }
            }.resume()
        }
    }
}
