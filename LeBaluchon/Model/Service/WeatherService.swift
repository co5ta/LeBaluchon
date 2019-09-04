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
    }
    
    // MARK: Properties
    
    /// Session configuration
    private var session = URLSession(configuration: .default)
    
    /// Task to execute
    private var task: URLSessionDataTask?
    
    /// arguments to request the API
    private var arguments: [String: String] {
        return [
            "id": Config.Weather.locationsID.joined(separator: ","),
            "APPID": Config.Weather.apiKey,
            "units": Config.Weather.unit
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
        guard let request = createRequestURL(url: Config.Weather.apiUrl, arguments: arguments) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                switch self.handleResult(error, response, data, Weather.self) {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let weather):
                     callback(.success(weather.weatherConditions))
                }
            }
        } 
        task?.resume()
    }
}
