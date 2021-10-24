//
//  ServiceWorker.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation
import UIKit

enum RequestError: Error {
    case invalidRequest
    case invalidResponse
    case errorResponse
    case invalidData
    case decodingError(error: Error)
}

struct RequestWorker {
    
    typealias objectResult<T> = (Result<T, Error>) -> Void
    typealias dataResult = (Result<Data, Error>) -> Void
    
    static func request<T: Decodable>(ofType: T.Type,
                                      baseURL: String,
                                      endpoint: String,
                                      method: RequestMethods = .GET,
                                      headers: [String: String]? = nil,
                                      query: [String: String]? = nil,
                                      body: [String: Any]? = nil,
                                      completion: @escaping objectResult<T>) {
        guard let urlRequest = RequestUtils.generateURLRequest(baseURL: baseURL,
                                                                endpoint: endpoint,
                                                                method: method,
                                                                headers: headers,
                                                                query: query,
                                                                body: body) else {
            completion(.failure(RequestError.invalidRequest))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _error = error {
                completion(.failure(_error))
            }
            
            guard let _response = response as? HTTPURLResponse else {
                completion(.failure(RequestError.invalidResponse))
                return
            }
            
            if RequestUtils.isSuccessfulResponse(code: _response.statusCode) {
                // Success
                if let _data = data,
                   let cleanedData = RequestWorker.clean(data: _data) {
                    do {
                        let decodedObject: T = try JSONDecoder().decode(T.self, from: cleanedData)
                        completion(.success(decodedObject))
                    } catch let decodingError {
                        completion(.failure(RequestError.decodingError(error: decodingError)))
                    }
                } else {
                    completion(.failure(RequestError.invalidData))
                }
            } else {
                // Failed
                completion(.failure(RequestError.errorResponse))
            }
            
        }.resume()
    }
    
    private static func clean(data: Data) -> Data? {
        let stringData = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        return stringData?.data(using: .utf8)
    }
}

