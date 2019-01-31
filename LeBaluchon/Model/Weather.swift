//
//  Weather.swift
//  LeBaluchon
//
//  Created by co5ta on 29/01/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Current weather conditions for a city
struct Weather {
    // MARK: - Properties
    
    /// Id of the city
    let placeId: Int
    /// Name of the city
    let placeName: String
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
}

extension Weather: Decodable {
    /// Relations between Weather properties and json
    enum CodingKeys: String, CodingKey {
        case placeId = "id"
        case placeName = "name"
        case conditions = "weather"
        case temperatures = "main"
    }
}

extension Weather {
    /// Detailed weather conditions
    struct Condition: Decodable {
        /// Name of the icon which illustrate the condition
        let icon: String
        /// Description of the condition
        let description: String
        
        /// Relations between Weather.Condition properties and json
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
        
        /// Relations between Weather.Temperatures properties and json
        enum CodingKeys: String, CodingKey {
            case current = "temp"
        }
    }
}
