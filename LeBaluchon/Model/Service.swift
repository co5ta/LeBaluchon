//
//  ServiceError.swift
//  LeBaluchon
//
//  Created by co5ta on 08/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// The Service protocol defines methods necessary interact more easily with an API
protocol Service {
    /// Create url to request an API by using URLComponents
    func createRequestURL(url: String, arguments: [String: String], path: String?) -> URL?
    /// Check if there is an anomaly in the API response
    func getFailure(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> Error?
}

extension Service {
    func createRequestURL(url: String, arguments: [String: String], path: String? = nil) -> URL? {
        guard var components = URLComponents(string: url) else {
            return nil
        }
        
        if let path = path {
            components.path += path
        }
        
        components.queryItems = []
        
        for (name, value) in arguments {
            components.queryItems?.append(URLQueryItem(name: name, value: value))
        }
        
        return components.url
    }
    
    func getFailure(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> Error? {
        if let error = error {
            return(NetworkError.errorFromAPI(message: error.localizedDescription))
        }
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            return(NetworkError.badResponse(message: "error \(response.statusCode)"))
        }
        
        if data == nil {
            return(NetworkError.emptyData)
        }
        
        return nil
    }
}
