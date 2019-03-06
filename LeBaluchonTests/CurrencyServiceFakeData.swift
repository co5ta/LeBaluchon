//
//  CurrencyServiceFakeData
//  LeBaluchonTests
//
//  Created by co5ta on 04/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

class CurrencyServiceFakeData {
    static let goodResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let badResponse = HTTPURLResponse(url: URL(string: "apple.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    static let error = FakeError()
    
    static var goodCurrenciesData: Data {
        return getGoodData(dataType: .currency)
    }

    static var goodRatesData: Data {
        return getGoodData(dataType: .rate)
    }
    
    static let badData = "data are bad here".data(using: .utf8)!
    
    private static func getGoodData(dataType: dataType) -> Data {
        let bundle = Bundle(for: CurrencyServiceFakeData.self)
        let url = bundle.url(forResource: dataType.rawValue, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }
    
    enum dataType: String {
        case currency = "currencies"
        case rate = "rates"
    }
}


class FakeError: Error {}
