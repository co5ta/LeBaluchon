//
//  ServiceFakeData.swift
//  LeBaluchonTests
//
//  Created by co5ta on 06/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

class ServiceFakeData {
    static let badApiUrl = "ç"
    
    static let goodResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let badResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    static let badData = "data are bad here".data(using: .utf8)!
    
    static var goodCurrenciesData: Data {
        return getGoodData(dataType: .currencies)
    }
    
    static var goodRatesData: Data {
        return getGoodData(dataType: .rates)
    }
    
    static var goodWeatherData: Data {
        return getGoodData(dataType: .weather)
    }
    
    private static func getGoodData(dataType: dataType) -> Data {
        let bundle = Bundle(for: ServiceFakeData.self)
        let url = bundle.url(forResource: dataType.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        
        return data
    }
}


extension ServiceFakeData {
    struct FakeError: Error {}
    static let error = FakeError()
}

extension ServiceFakeData {
    enum dataType: String {
        case currencies
        case rates
        case weather
    }
}
