//
//  Rates.swift
//  LeBaluchon
//
//  Created by co5ta on 22/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Currency rates
struct Rates: Decodable {
    /// List of currencies with their rates
    let values: [String: Float]
}

// ==============================================

// MARK: - Decoding entities

extension Rates {
    /// Relations between properties and json
    enum CodingKeys: String, CodingKey {
        case values = "rates"
    }
}
