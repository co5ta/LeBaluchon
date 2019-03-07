//
//  ServiceFakeData.swift
//  LeBaluchonTests
//
//  Created by co5ta on 06/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Simulate data that service can receive when they request an API
class ServiceFakeData {
    /// Bad url format
    static let badApiUrl = "ç"
    
    /// Response with good status code
    static let goodResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    /// Response with bad status code
    static let badResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    /// Data that doesn't contain what is expected
    static let badData = "data are bad here".data(using: .utf8)!
    
    /// Example of good currencies data
    static var goodCurrenciesData: Data {
        return getGoodData(dataType: .currencies)
    }
    
    /// Example of good rates data
    static var goodRatesData: Data {
        return getGoodData(dataType: .rates)
    }
    
    /// Example of good weather data
    static var goodWeatherData: Data {
        return getGoodData(dataType: .weather)
    }
    
    /// Example of good translation data
    static var goodTranslationData: Data {
        return getGoodData(dataType: .translation)
    }
    
    /// Give good data from json
    private static func getGoodData(dataType: dataType) -> Data {
        let bundle = Bundle(for: ServiceFakeData.self)
        let url = bundle.url(forResource: dataType.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        
        return data
    }
}

extension ServiceFakeData {
    /// Struct to simulate an error
    struct FakeError: Error {}
    
    /// Any error
    static let error = FakeError()
}

extension ServiceFakeData {
    /// Type of data we can have in each test json
    enum dataType: String {
        case currencies
        case rates
        case weather
        case translation
    }
}
