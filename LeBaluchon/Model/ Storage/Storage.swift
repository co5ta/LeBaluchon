//
//  StorageKey.swift
//  LeBaluchon
//
//  Created by co5ta on 22/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

struct Storage {
    static var shared = UserDefaults.standard
    static var test = UserDefaults.init(suiteName: "test")!
    
    ///string key for data storage
    static let languageSource = "sourceLanguage"
    static let languageTarget = "targetLanguage"
    static let currencySourceIndex = "sourceCurrency"
    static let currencyTargetIndex = "targetCurrency"
    static let currencies = "currencies"
    static let currenciesLastUpdate = "currenciesLastUpdate"
    static let weather = "weather"
    static let weatherLastUpdate = "weatherLastUpdate"
}
