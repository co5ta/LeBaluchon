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
    }
    
    // MARK: Properties
    
    /// Session configuration
    private var session = URLSession(configuration: .default)
    
    /// Task to request data
    private var task: URLSessionDataTask?
    
    /// Arguments to request the API
    private var arguments: [String: String] {
        return [ "access_key": Config.Currency.apiKey ]
    }
}

// MARK: - Methods

extension CurrencyService {
    
    func getCurrencies(callback: @escaping (Result<[Currency], NetworkError>) -> Void) {
        getCurrenciesNames { (result) in
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
        guard let url = createRequestURL(url: Config.Currency.apiUrl, arguments: arguments, path: Config.Currency.endpointCurrencies) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let result = self?.handleResult(error, response, data, CurrenciesNames.self) else { return }
                switch result {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let currenciesNames):
                    callback(.success(currenciesNames.symbols))
                }
            }
        }
        task?.resume()
    }
    
    /// Fetch currency rates
    func getCurrenciesRates(callback: @escaping (Result<[String: Float], NetworkError>) -> Void) {
        guard let url = createRequestURL(url: Config.Currency.apiUrl, arguments: arguments, path: Config.Currency.endpointRates) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let result = self?.handleResult(error, response, data, CurrenciesRates.self) else { return }
                switch result {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let currenciesRates):
                    callback(.success(currenciesRates.rates))
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
            if Config.Currency.mainCurrenciesCode.contains(currencyCode) {
                mainCurrencies.append(newCurrency)
            } else {
                currencies.append(newCurrency)
            }
        }
        return mainCurrencies.sorted { $0.name < $1.name } + currencies.sorted { $0.name < $1.name }
    }
}
