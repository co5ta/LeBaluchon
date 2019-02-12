//
//  ServiceError.swift
//  LeBaluchon
//
//  Created by co5ta on 08/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

protocol Service {
    func createRequestURL(url: String, arguments: [String: String], path: String?) -> URL?
    func getFailure(_ error: Error?, _ response: URLResponse?, _ data: Data?) -> Error?
}

extension Service {
    func createRequestURL(url: String, arguments: [String: String], path: String? = nil) -> URL? {
        guard var components = URLComponents(string: url) else {
            return nil
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
