//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by co5ta on 03/08/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

/// Object that requests the currency API
class CurrencyService {
    // MARK: - Singleton
    
    /// Property for singleton pattern
    static let shared = CurrencyService()
    /// Init for singleton pattern
    private init() {}
    
    // MARK: - Properties
    
    /// Base URL of the currency API
    fileprivate let apiUrl = "http://data.fixer.io/api/"
    /// Key to access the API
    fileprivate let apiKey = "5f997405a289e163b37336eeed0c04bb"
    
    /// Session configuration
    fileprivate var session = URLSession(configuration: .default)
    /// Task to execute to get currencies list
    fileprivate var currenciesTask: URLSessionDataTask?
    /// Task to execute to get currencies rates
    fileprivate var ratesTask: URLSessionDataTask?

}

// MARK: - Data subtype

extension CurrencyService {
    /// Resources that can be asked to the API
    enum Resource: String {
        /// Resource available in the API
        case Rates = "latest", Currencies = "symbols"
    }
}

// MARK: - Requests

extension CurrencyService {
    /**
     Fetch the list of all currencies
     - Parameters:
     - callback: closure to manage data returned by the API
     - success: indicates if the request succeeded or not
     - data: contains the data returned by the API
     */
    func getCurrencies(callback: @escaping (_ success: Bool, _ currencies: [Currency]?) -> ()) {
        guard let url = createRequestURL(for: .Currencies) else {
            print("Error creating the request URL")
            return
        }
        
        currenciesTask?.cancel()
        currenciesTask = session.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                print("The request returns an error: \n" + error!.localizedDescription)
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("The request response is not 200")
                callback(false, nil)
                return
            }
            
            guard let data = data else {
                print("The request did not return data")
                callback(false, nil)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                print("The request did not return data")
                callback(false, nil)
                return
            }
            
            guard let jsonArray = json as? [String: Any] else {
                print("errors jsonArray")
                callback(false, nil)
                return
            }
            
            guard let symbols = jsonArray["symbols"] as? [String: String] else {
                print("errors symbols")
                callback(false, nil)
                return
            }
            
            let mainCodes = ["EUR", "USD"]
            var currencies = [Currency]()
            var secondaryCurrencies = [Currency]()
            
            for (currencyCode, currencyName) in symbols {
                let newCurrency = Currency(code: currencyCode, name: currencyName)
                if mainCodes.contains(currencyCode) {
                    currencies.append(newCurrency)
                } else {
                    secondaryCurrencies.append(newCurrency)
                }
            }
            
            currencies.sort(by: { (firstCurrency, secondCurrency) -> Bool in
                firstCurrency.name < secondCurrency.name
            })
            
            secondaryCurrencies.sort(by: { (firstCurrency, secondCurrency) -> Bool in
                firstCurrency.name < secondCurrency.name
            })
            
            currencies += secondaryCurrencies
            
            callback(true, currencies)
            
        })
        currenciesTask?.resume()
    }
    
    /**
     Fetch curency rates relative to EUR as base
     - Parameters:
        - callback: closure to manage data returned by the API
        - success: indicates if the request succeeded or not
        - data: contains the data returned by the API
    */
    func getRates(callback: @escaping (_ success: Bool, _ rates: RelativeRates?) -> ()) {
        guard let url = createRequestURL(for: .Rates) else {
            print("Error creating the request URL")
            return
        }
        
        ratesTask?.cancel()
        ratesTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("The request returns an error: \n" + error!.localizedDescription)
                callback(false, nil)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("The request response is not 200")
                callback(false, nil)
                return
            }
            
            guard let data = data else {
                print("The request did not return data")
                callback(false, nil)
                return
            }
            
            guard let rates = try? JSONDecoder().decode(RelativeRates.self, from: data) else {
                print("Error on json decode")
                callback(false, nil)
                return
            }
 
            callback(true, rates)
        }
        ratesTask?.resume()
    }
    
    /**
     Create the URL for the request to execute
     - parameter resource: resource asked to the API
     - Returns: The suitable URL to ask a resource to the API
     */
    private func createRequestURL(for resource: Resource) -> URL? {
        guard var components = URLComponents(string: apiUrl) else {
            print("Could not build URLComponents")
            return nil
        }
        
        components.path += resource.rawValue
        
        components.queryItems = [
            URLQueryItem(name: "access_key", value: apiKey)
        ]
        
        return components.url
    }
}
