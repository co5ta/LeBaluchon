//
//  Currency.swift
//  LeBaluchon
//
//  Created by co5ta on 01/08/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

/// Object that represents a currency
struct Currency {
    let code: String
    let name: String
}

/// Object that groups rates relative to a currency
struct RelativeRates: Decodable {
    let base: String
    let timestamp: Int
    let rates: [String: Float]
}

