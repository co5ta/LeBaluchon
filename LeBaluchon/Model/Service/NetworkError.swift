//
//  Error.swift
//  LeBaluchon
//
//  Created by co5ta on 11/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation
import UIKit

/// Give information on the error encountered in a request
enum NetworkError: Error {
    /// Error occured during the request
    case invalidRequestURL, errorFromAPI(String), badResponse, badResponseNumber(String), emptyData, jsonDecodeFailed
    
    /// Prepare an alert to explain an error
    static func alert(_ networkError: NetworkError) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: networkError.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(confirmAction)
        return alert
    }
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidRequestURL:
            return "Invalid data provider"
        case .errorFromAPI(let message):
            return message
        case .badResponse:
            return "The request returned a bad response"
        case .badResponseNumber(let message):
            return message
        case .emptyData:
            return "No data returned"
        case .jsonDecodeFailed:
            return "Data decoding failed"
        }
    }
}
