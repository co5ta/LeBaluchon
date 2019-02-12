//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by co5ta on 27/12/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

/// Class that fetch data from the weather API
class WeatherService: Service {
    // MARK: Properties
    
    /// Base URL of the currency API
    private let apiUrl = "https://api.openweathermap.org/data/2.5/group"
    
    /// API key
    private let apiKey = "951fdc1ed16481d96c1728da1c3cf6cd"
    
    /// ID of the cities
    private let citiesId: [String] = ["5128581", "6455259"]
    
    /// Metric unit format for celcius degrees
    private let unitFormat = "metric"
    
    /// Arguments that details what to ask to the API and include the API Key
    private var arguments: [String: String] {
        return [
            "id": citiesId.joined(separator: ","),
            "APPID": apiKey,
            "units": unitFormat
        ]
    }
    
    /// Session configuration
    private let session = URLSession(configuration: .default)
    
    /// Task to execute
    private var task: URLSessionDataTask?
    
    /// Weather data given by the API
    var cities: [Weather.City] = []
    
    // MARK: Singleton
    
    /// Unique instance of WeatherService
    static var shared = WeatherService()
    
    /// Private initializer
    private init() {}
}

// MARK: - Methods

extension WeatherService {
    
    /**
     Fetch weather condition relative to a city
     - Parameters:
     - callback: closure to manage data returned by the API
     - success: indicates if the request succeeded or not
     - data: contains the data returned by the API
     */
    func getConditions(callback: @escaping (Error?) -> Void) {
        guard let request = createRequestURL(url: apiUrl, arguments: arguments) else {
            callback(NetworkError.invalidRequestURL)
            return
        }
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let failure = self.getFailure(error, response, data) {
                    callback(failure)
                    return
                }
                
                guard let data = data, let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(NetworkError.jsonDecodeFailed)
                    return
                }
                
                self.cities = weather.cities
                callback(nil)
            }
        } 
        task?.resume()
    }
}
