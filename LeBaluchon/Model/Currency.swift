//
//  Currency.swift
//  LeBaluchon
//
//  Created by co5ta on 01/08/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

/// Struct that represents a currency
struct Currency {
    /// Code name of the currency
    let code: String
    
    /// Full name of the currency
    let name: String
}

// =============================================

// MARK: - Decoding entities

/// Struct that contains currencies taken from the API
struct CurrenciesList: Decodable {
    /// The list of currencies resulting from the json API
    let symbols: [String: String]
}
