//
//  CurrencyService.swift
//  LeBaluchon
//
//  Created by co5ta on 03/08/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

/// Class that fetch data from the currency API
class CurrencyService: Service {
    // MARK: Singleton
    
    /// Property for singleton pattern
    static let shared = CurrencyService()
    
    /// Init for singleton pattern
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
    
    /// Task to request data
    private var task: URLSessionDataTask?
    
    /// Base URL of the currency API
    private var apiUrl = "http://data.fixer.io/api/"
    
    /// Key to access the API
    private let apiKey = "5f997405a289e163b37336eeed0c04bb"
    
    /// Arguments to request the API
    private var arguments: [String: String] {
        return [ "access_key": apiKey ]
    }
    
    /// Code of main currencies that must be on top of the list
    private let mainCurrenciesCode = ["EUR", "USD"]
}

// MARK: - Data type

extension CurrencyService {
    /// Data type that can be asked
    private enum Resource: String {
        /// Data type available in the API
        case Rates = "latest", Currencies = "symbols"
    }
}

// MARK: - Methods

extension CurrencyService {
    
    func getCurrencies(callback: @escaping (Result<[Currency], NetworkError>) -> Void) {
        self.getCurrenciesNames { (result) in
            switch result {
            case .failure(let error):
                callback(.failure(error))
            case .success(let namesData):
                self.getCurrenciesRates { (result) in
                    switch result {
                    case .failure(let error):
                        callback(.failure(error))
                    case .success(let ratesData):
                        let currencies = self.createCurrenciesObjects(with: namesData, and: ratesData)
                        callback(.success(currencies))
                    }
                }
            }
        }
    }
    
     /// Fetch currencies names
    func getCurrenciesNames(callback: @escaping (Result<[String: String], NetworkError>) -> Void) {
        guard let url = createRequestURL(url: apiUrl, arguments: arguments, path: Resource.Currencies.rawValue) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                switch self.handleResult(error, response, data, CurrenciesList.self) {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let data):
                    callback(.success(data.symbols))
                }
            }
        }
        task?.resume()
    }
    
    /// Fetch currency rates
    func getCurrenciesRates(callback: @escaping (Result<[String: Float], NetworkError>) -> Void) {
        guard let url = createRequestURL(url: apiUrl, arguments: arguments, path: Resource.Rates.rawValue) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                switch self.handleResult(error, response, data, Rates.self) {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let data):
                    callback(.success(data.rates))
                }
            }
        }
        task?.resume()
    }
    
    /**
     Transform currencies list from API to array of Currency
     - Parameters:
     - currenciesList: The list of currencies decoded from json
     - Returns: An array of Currency ordered alphabetically
     */
    private func createCurrenciesObjects(with currenciesNames: [String: String], and currenciesRates: [String: Float]) -> [Currency] {
        var mainCurrencies = [Currency]()
        var currencies = [Currency]()
        
        for (currencyCode, currencyRate) in currenciesRates {
            let currencyName = currenciesNames[currencyCode] ?? currencyCode
            let newCurrency = Currency(code: currencyCode, name: currencyName, rate: currencyRate)
            if self.mainCurrenciesCode.contains(currencyCode) {
                mainCurrencies.append(newCurrency)
            } else {
                currencies.append(newCurrency)
            }
        }
        return mainCurrencies.sorted { $0.name < $1.name } + currencies.sorted { $0.name < $1.name }
    }
}
