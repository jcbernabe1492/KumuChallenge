//
//  ServiceWorker.swift
//  KumuChallenge
//
//  Created by Jc Bernabe on 9/26/21.
//

import Foundation

enum RequestError: Error {
    case invalidRequest
    case invalidResponse
    case errorResponse
    case invalidData
    case decodingError(error: Error)
}

struct ServiceWorker {
    
    private let urlSession: URLSession
    
    typealias objectResult<T> = (Result<T, Error>) -> Void
    
    static func request<T: Decodable>(ofType: T.Type,
                                      baseURL: String,
                                      endpoint: String,
                                      method: RequestMethods = .GET,
                                      headers: [String: String]? = nil,
                                      query: [String: String]? = nil,
                                      body: [String: Any]? = nil,
                                      completion: @escaping objectResult<T>) {
        guard let urlRequest = ServiceWorker.generateURLRequest(baseURL: baseURL,
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
            
            if 200 ... 299 ~= _response.statusCode {
                // Success
                if let _data = data,
                   let cleanedData = ServiceWorker.clean(data: _data) {
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
    
    private static func generateURLRequest(baseURL: String,
                                           endpoint: String,
                                           method: RequestMethods,
                                           headers: [String: String]? = nil,
                                           query: [String: String]? = nil,
                                           body: [String: Any]? = nil) -> URLRequest? {
        
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            return nil
        }
        
        if let _query = query {
            var queryItems: [URLQueryItem] = []
            _query.forEach { (key, value) in
                queryItems.append(URLQueryItem(name: key, value: value))
            }
            urlComponents.queryItems = queryItems
        }
        
        var urlRequest = URLRequest(url: urlComponents.url!)
        
        urlRequest.httpMethod = method.rawValue
        
        if let _headers = headers {
            _headers.forEach { (key, value) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let _body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: _body, options: [])
                urlRequest.httpBody = jsonData
            } catch let error {
                dump("\(error)")
            }
        }
        
        return urlRequest
    }
    
    private static func clean(data: Data) -> Data? {
        let stringData = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
        return stringData?.data(using: .utf8)
    }
}

