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
    let placeId: Int
    let placeName: String
    let conditions: [Condition]
    let temperatures: Temperature
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
        let id: Int
        let title: String
        let description: String
        
        /// Relations between Weather.Condition properties and json
        enum CodingKeys: String, CodingKey {
            case id
            case title = "main"
            case description
        }
    }
}

extension Weather {
    /// Detailed temperatures
    struct Temperature: Decodable {
        let current: Float
        let min: Float
        let max: Float
        
        /// Relations between Weather.Temperatures properties and json
        enum CodingKeys: String, CodingKey {
            case current = "temp"
            case min = "temp_min"
            case max = "temp_max"
        }
    }
}
