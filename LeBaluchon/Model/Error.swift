//
//  Error.swift
//  LeBaluchon
//
//  Created by co5ta on 11/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidRequestURL
    case errorFromAPI(message: String)
    case badResponse(message: String)
    case emptyData
    case jsonDecodeFailed
}
