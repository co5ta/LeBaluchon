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
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: ServiceFakeData.badApiUrl)
        
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
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: ServiceFakeData.badApiUrl)
        
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
        let session = URLSessionFake(nil, nil, ServiceFakeData.error)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(nil, nil, ServiceFakeData.error)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(nil, ServiceFakeData.badResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(nil, ServiceFakeData.badResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(nil, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(nil, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(ServiceFakeData.badData, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(ServiceFakeData.badData, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
        let session = URLSessionFake(ServiceFakeData.goodCurrenciesData, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
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
    
    func testGetRatesShouldCallbackNilErrorWhenRequestReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(ServiceFakeData.goodRatesData, ServiceFakeData.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        
        // When
        currencyService.getRates { (error) in
            // Then
            XCTAssertNil(error)
            XCTAssertEqual(currencyService.rates["EUR"],  1)
            XCTAssertEqual(currencyService.rates["USD"],  1.132394)
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
