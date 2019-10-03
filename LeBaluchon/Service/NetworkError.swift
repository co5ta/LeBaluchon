//
//  Error.swift
//  LeBaluchon
//
//  Created by co5ta on 11/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Give information on the error encountered in a request
enum NetworkError: Error, Equatable {
    /// Error occured during the request
    case invalidRequestURL
    case errorFromAPI(String)
    case badResponse
    case badResponseNumber(String)
    case emptyData
    case jsonDecodeFailed
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequestURL:
            return "Invalid data provider"
        case .errorFromAPI(let message):
            return "An Error occured in the request: \(message)"
        case .badResponse:
            return "The response is not an HTTPURLResponse"
        case .badResponseNumber(let message):
            return "The request returned a bad response (code \(message))"
        case .emptyData:
            return "The request did not return any data"
        case .jsonDecodeFailed:
            return "Data decoding failed"
        }
    }
}
