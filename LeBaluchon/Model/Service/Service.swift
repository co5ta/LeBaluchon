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
    func handleResult<T>(_ error: Error?, _ response: URLResponse?, _ data: Data?,
                         _ dataType: T.Type) -> Result<T, NetworkError> where T: Decodable
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
        guard var components = URLComponents(string: url) else { return nil }
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
    func handleResult<T>(_ error: Error?, _ response: URLResponse?, _ data: Data?, _ dataType: T.Type)
        -> Result<T, NetworkError> where T: Decodable {
        if let error = error {
            return .failure(.errorFromAPI(error.localizedDescription))
        }
        guard let response = response as? HTTPURLResponse else {
            return .failure(.badResponse)
        }
        guard (200...299).contains(response.statusCode) else {
            return .failure(.badResponseNumber("\(response.statusCode)"))
        }
        guard let data = data else {
            return .failure(.emptyData)
        }
        guard let decodedData = try? JSONDecoder().decode(dataType, from: data) else {
            return .failure(.jsonDecodeFailed)
        }
        return .success(decodedData)
    }
}
