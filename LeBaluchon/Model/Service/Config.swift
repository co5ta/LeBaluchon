//
//  Config.swift
//  LeBaluchon
//
//  Created by co5ta on 29/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

enum Config {
    static let updateInterval = 1
    
    enum Currency {
        static let apiUrl = "http://data.fixer.io/api/"
        static let apiKey = "5f997405a289e163b37336eeed0c04bb"
        static let endpoints = (names: "symbols", rates: "latest")
        static let mainCurrenciesCode = ["EUR", "USD"]
    }
    
    enum Weather {
        static let apiUrl = "https://api.openweathermap.org/data/2.5/group"
        static let apiKey = "951fdc1ed16481d96c1728da1c3cf6cd"
        static let locationsID = ["5128581", "6455259"]
        static let unit = "metric"
    }
    
    enum Translation {
        static let apiUrl = "https://translation.googleapis.com/language/translate/v2"
        static let apiKey = "AIzaSyDX07xWgK_IQRN3wXHFBopwycC9AzachOU"
    }
}
