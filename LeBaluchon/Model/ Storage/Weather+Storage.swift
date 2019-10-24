//
//  Weather+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 30/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

// MARK: Data update

extension WeatherCondition {
    /// Return true if last update time is superior to update interval value
    static var needsUpdate: Bool {
        guard let lastUpdate = lastUpdate else { return true }
        let difference = Calendar.current.dateComponents([.hour], from: lastUpdate, to: Date())
        guard let hour = difference.hour, hour < Config.updateInterval else { return true }
        return false
    }
}

// MARK: - Data storage

extension WeatherCondition {
    /// Date of the last update
    static var lastUpdate: Date? {
        get { return Storage.shared.object(forKey: Storage.weatherLastUpdate) as? Date }
        set { Storage.shared.set(newValue, forKey: Storage.weatherLastUpdate) }
    }
    
    /// Stored weather conditions data
    static var list: [WeatherCondition] {
        get {
            guard let weatherData = Storage.shared.data(forKey: Storage.weather) else { return [] }
            guard let weatherConditions = try? JSONDecoder().decode([WeatherCondition].self, from: weatherData) else { return [] }
            return weatherConditions
        }
        set {
            guard let weatherData = try? JSONEncoder().encode(newValue) else { return }
            Storage.shared.set(weatherData, forKey: Storage.weather)
            lastUpdate = Date()
        }
    }
}
