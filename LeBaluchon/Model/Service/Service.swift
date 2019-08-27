//
//  ServiceError.swift
//  LeBaluchon
//
//  Created by co5ta on 08/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// The Service protocol defines necessary methods to interact more easily with an API
protocol Service {
    /// Create url to request an API by using URLComponents
    func createRequestURL(url: String, arguments: [String: String], path: String) -> URL?
    
    /// Check if there is an anomaly in the API response
    func getFailure(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> NetworkError?
}

extension Service {
    /**
     Create url to request an API by using URLComponents
     - Parameters:
     - url: URL of the API
     - arguments: Parameters of the request
     - path: Add path to the request
     */
    func createRequestURL(url: String, arguments: [String: String], path: String = "") -> URL? {
        guard var components = URLComponents(string: url) else {
            return nil
        }
        
        components.path += path
        components.queryItems = arguments.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        return components.url
    }
    
    /**
     Check if there is an anomaly in the API response
     - Parameters:
     - error: error returned by the request
     - response: response returned by the request
     - path: data returned by the request
     */
    func getFailure(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> NetworkError? {
        if error != nil {
            return(NetworkError.errorFromAPI)
        }
        
        if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            return(NetworkError.badResponse)
        }
        
        if data == nil {
            return(NetworkError.emptyData)
        }
        
        return nil
    }
    
    
    func handleResult(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> Result<Data, NetworkError> {
        if error != nil {
            return .failure(NetworkError.errorFromAPI)
        } else if let response = response as? HTTPURLResponse, response.statusCode != 200 {
            return .failure(NetworkError.badResponse)
        } else if data == nil {
            return .failure(NetworkError.emptyData)
        }
        return .success(data!)
    }
}
