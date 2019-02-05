//
//  Weather.swift
//  LeBaluchon
//
//  Created by co5ta on 29/01/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Object that contains data given by the weather API
struct Weather: Decodable {
    /// Weather for each city requested
    let cities: [City]
    
    /// Relations between properties and json
    enum CodingKeys: String, CodingKey {
        case cities = "list"
    }
}

extension Weather {
    /// Current weather conditions for a city
    struct City: Decodable {
        /// Name of the city
        let name: String
        
        /// List of current weather conditions
        private let conditions: [Condition]
        
        /// Temperature in the city
        private let temperatures: Temperature
        
        /// Temperature in text
        var celciusTemperatures: String {
            return "\(Int(temperatures.current))° C"
        }
        
        /// Primary weather condition
        var primaryCondition: Condition {
            return conditions[0]
        }
        
        /// Relations between properties and json
        enum CodingKeys: String, CodingKey {
            case name
            case conditions = "weather"
            case temperatures = "main"
        }
    }
}

extension Weather {
    /// Detailed weather conditions
    struct Condition: Decodable {
        /// Name of the icon which illustrate the weather condition
        let icon: String
        
        /// Description of the weather condition
        let description: String
        
        /// Relations between properties and json
        enum CodingKeys: String, CodingKey {
            case icon
            case description
        }
    }
}

extension Weather {
    /// Detailed temperatures
    struct Temperature: Decodable {
        /// Current temperature
        let current: Float
        
        /// Relations between properties and json
        enum CodingKeys: String, CodingKey {
            case current = "temp"
        }
    }
}
