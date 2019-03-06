//
//  Error.swift
//  LeBaluchon
//
//  Created by co5ta on 11/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Give information on the error encountered in a request
enum NetworkError: Error {
    /// The request URL could not be generate
    case invalidRequestURL
    
    /// The API returned an error
    case errorFromAPI
    
    /// The request returned an bad response
    case badResponse
    
    /// Data are empty
    case emptyData
    
    /// Json decoding failed
    case jsonDecodeFailed
}
