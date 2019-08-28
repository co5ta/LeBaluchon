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
    // MARK: Singleton
    
    /// Unique instance of WeatherService
    static var shared = WeatherService()
    
    /// Private initializer
    private init() {}
    
    // MARK: Dependency injection
    
    /// Custom session and apiUrl for tests
    init(session: URLSession, apiUrl: String? = nil) {
        self.session = session
        if let apiUrl = apiUrl {
            self.apiUrl = apiUrl
        }
    }
    
    // MARK: Properties
    
    /// Session configuration
    private var session = URLSession(configuration: .default)
    
    /// Task to execute
    private var task: URLSessionDataTask?
    
    /// Base URL of the currency API
    private var apiUrl = "https://api.openweathermap.org/data/2.5/group"
    
    /// API key
    private let apiKey = "951fdc1ed16481d96c1728da1c3cf6cd"
    
    /// ID of the locations
    private let locationsID: [String] = ["5128581", "6455259"]
    
    /// Metric unit format for celcius degrees
    private let unitFormat = "metric"
    
    /// arguments to request the API
    private var arguments: [String: String] {
        return [
            "id": locationsID.joined(separator: ","),
            "APPID": apiKey,
            "units": unitFormat
        ]
    }
}

// MARK: - Methods

extension WeatherService {
    
    /**
     Fetch weather conditions for given locations
     - parameter callback: closure to manage the result of the request
     - parameter result: weather conditions or network error
     */
    func getConditions(callback: @escaping (_ result: Result<[WeatherCondition], NetworkError>) -> Void) {
        guard let request = createRequestURL(url: apiUrl, arguments: arguments) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                switch self.handleResult(error, response, data, Weather.self) {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let data):
                     callback(.success(data.weatherConditions))
                }
            }
        } 
        task?.resume()
    }
}
