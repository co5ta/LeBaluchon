//
//  WeatherService.swift
//  LeBaluchon
//
//  Created by co5ta on 27/12/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

class WeatherService {
    // MARK: - Singleton
    
    /// Unique instance of WeatherService
    static var shared = WeatherService()
    /// Private initializer
    private init() {}
    
    // MARK: - Properties
    
    /// Base URL of the currency API
    private let apiUrl = "https://api.openweathermap.org/data/2.5/weather"
    /// API key
    private let apiKey = "951fdc1ed16481d96c1728da1c3cf6cd"
    /// New York city ID
    private let newYorkId = "5128581"
    /// Metric unit format for celcius degrees
    private let unitFormat = "metric"
    
    /// Session configuration
    private let mysession = URLSession(configuration: .default)
    /// Task to execute
    private var task: URLSessionDataTask?
}

// MARK: - Requests
extension WeatherService {
    /**
     Fetch weather condition relative to a city
     - Parameters:
     - callback: closure to manage data returned by the API
     - success: indicates if the request succeeded or not
     - data: contains the data returned by the API
     */
    func getConditions(callback: @escaping (Bool, Weather?) -> Void) {
        guard let request = createRequestURL() else {
            print("error url")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                print(data as Any)
                guard let data = data else {
                    callback(false, nil)
                    print("data error")
                    return
                }
                
                guard error == nil else {
                    callback(false, nil)
                    print("error not nil")
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    print("response error")
                    return
                }
                
                guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                    callback(false, nil)
                    print("json error")
                    return
                }
                
                callback(true, weather)
            }
        } 
        task?.resume()
    }
    
    /**
     Create the URL for the request to execute
     - Returns: The suitable URL to ask a weather condition to the API
     */
    private func createRequestURL() -> URL? {
        guard var components = URLComponents(string: apiUrl) else {
            print("Could not build URLComponents")
            return nil
        }
        
        components.queryItems = [
            URLQueryItem(name: "id", value: newYorkId),
            URLQueryItem(name: "APPID", value: apiKey),
            URLQueryItem(name: "units", value: unitFormat),
        ]
        
        return components.url
    }
}
