//
//  Utils.swift
//  KumuChallenge
//
//  Created by Jc on 10/25/21.
//

import Foundation

/// Utility functions for request handling.
struct RequestUtils {
    
    /// Generate *URLRequest* to be used in *URLSessions*
    /// - Parameters:
    ///   - baseURL: Base URL of request.
    ///   - endpoint: Request endpoint.
    ///   - method: HTTP method to be used on the request.
    ///   - headers: *Optional* custom request headers.
    ///   - query: *Optional* custom request queries.
    ///   - body: *Optional* custom request body.
    /// - Returns: *URLRequest* object generated using provided parameters.
    static func generateURLRequest(baseURL: String,
                                   endpoint: String,
                                   method: RequestMethods = RequestMethods.GET,
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
    
    /// Check if response code translates is equivalent to a succesful response.
    ///
    /// Used reference: https://restfulapi.net/http-status-codes/
    /// - Parameter code: HTTP response status code.
    /// - Returns: *Boolean* value if succesful or not.
    static func isSuccessfulResponse(code: Int) -> Bool {
        return 200 ... 299 ~= code
    }
}
