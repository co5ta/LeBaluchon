//
//  ServiceFakeData.swift
//  LeBaluchonTests
//
//  Created by co5ta on 06/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Simulate data that service can receive when they request an API
class FakeResponseData {
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
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: dataType.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
}

extension FakeResponseData {
    /// Struct to simulate an error
    struct FakeError: Error, LocalizedError {
        var errorDescription: String? = "A fake error occured"
    }
    
    /// Any error
    static let error = FakeError()
}

extension FakeResponseData {
    /// Type of data we can have in each test json
    enum dataType: String {
        case currencies, rates, weather, translation
    }
}
