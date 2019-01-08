//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by co5ta on 27/12/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

class WeatherService {
    
    // MARK: - Properties
    // 2459115
    /// Base URL of the currency API
    let apiUrl = URL(string: "https://weather-ydn-yql.media.yahoo.com/forecastrss?w=2502265")
    /// Consumer key for the API
    let consumerKey = "dj0yJmk9clVrSUVMajk2NlJXJmQ9WVdrOVdsaGhjbGRDTmpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD1mMQ--"
    /// Consumer secret key for the API
    let consumerSecret = "2610e340fcb13619b2a8e3bb9254c1bc8dc03dfa"
    
    /// Session configuration
    let mysession = URLSession(configuration: .default)
}

// MARK: - Requests
extension WeatherService {
    func getConditions() {}
}
