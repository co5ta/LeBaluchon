//
//  CurrencyServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by co5ta on 04/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class CurrencyServiceTestCase: XCTestCase {
    let expectation = XCTestExpectation(description: "Wait for queue change")
    
    func testGetCurrenciesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let sessionFake = URLSessionFake(nil, nil, nil)
        let badApiUrl = "ç"
        let currencyService = CurrencyService(session: sessionFake, apiUrl: badApiUrl)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.invalidRequestURL)
            XCTAssert(currencyService.currencies.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let sessionFake = URLSessionFake(nil, nil, nil)
        let badApiUrl = "ç"
        let currencyService = CurrencyService(session: sessionFake, apiUrl: badApiUrl)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.invalidRequestURL)
            XCTAssert(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let sessionFake = URLSessionFake(nil, nil, CurrencyServiceFakeData.error)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.errorFromAPI)
            XCTAssert(currencyService.currencies.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let sessionFake = URLSessionFake(nil, nil, CurrencyServiceFakeData.error)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.errorFromAPI)
            XCTAssert(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetCurrenciesShouldCallbackBadResponseWhenCurrencySessionReturnsBadResponse() {
        // Given
        let sessionFake = URLSessionFake(nil, CurrencyServiceFakeData.badResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.badResponse)
            XCTAssert(currencyService.currencies.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackBadResponseWhenCurrencySessionReturnsBadResponse() {
        // Given
        let sessionFake = URLSessionFake(nil, CurrencyServiceFakeData.badResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.badResponse)
            XCTAssert(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let sessionFake = URLSessionFake(nil, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.emptyData)
            XCTAssert(currencyService.currencies.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let sessionFake = URLSessionFake(nil, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.emptyData)
            XCTAssert(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let sessionFake = URLSessionFake(CurrencyServiceFakeData.badData, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.jsonDecodeFailed)
            XCTAssert(currencyService.currencies.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let sessionFake = URLSessionFake(CurrencyServiceFakeData.badData, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssert(error as! NetworkError == NetworkError.jsonDecodeFailed)
            XCTAssert(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let sessionFake = URLSessionFake(CurrencyServiceFakeData.goodCurrenciesData, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getCurrencies { (error) in
            // Then
            XCTAssertNil(error)
            XCTAssertEqual(currencyService.currencies[0].code,  "EUR")
            XCTAssertEqual(currencyService.currencies[1].code,  "USD")
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetRatesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let sessionFake = URLSessionFake(CurrencyServiceFakeData.goodRatesData, CurrencyServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: sessionFake)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssertNil(error)
            XCTAssertFalse(currencyService.rates.isEmpty)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
