//
//  ServiceFakeData.swift
//  LeBaluchonTests
//
//  Created by co5ta on 06/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Simulate data that service can receive when they request an API
class FakeResult {
    /// Bad url format
    static let badApiUrl = "a://@@"
    
    /// Response with good status code
    static let goodResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    
    /// Response with bad status code
    static let badResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    /// Data that doesn't contain what is expected
    static let badData = "data are bad here".data(using: .utf8)!
    
    /// Give good data from json
    static func getGoodData(_ dataType: dataType) -> Data {
        let bundle = Bundle(for: FakeResult.self)
        let url = bundle.url(forResource: dataType.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    static let decodedCurrenciesNames = [
        "AED": "United Arab Emirates Dirham",
        "AFN": "Afghan Afghani",
        "AUD": "Australian Dollar",
        "USD": "United States Dollar",
        "EUR": "Euro"
    ]
    
    static let decodedCurrenciesRates: [String: Float] = [
        "USD": 1.132394,
        "EUR": 1,
        "AED": 4.159274,
        "AFN": 84.567006,
        "AUD": 1.611895,
    ]
}

extension FakeResult {
    /// Struct to simulate an error
    struct FakeError: Error, LocalizedError {
        var errorDescription: String? = "A fake error occured"
    }
    
    /// Any error
    static let error = FakeError()
}

extension FakeResult {
    /// Type of data we can have in each test json
    enum dataType: String {
        case currencies, rates, weather, translation
    }
}
