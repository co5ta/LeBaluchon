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
    
    func testGetCurrenciesNamesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: FakeResult.badApiUrl)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidRequestURL.localizedDescription)
            case .success:
                XCTAssertFalse(true)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: FakeResult.badApiUrl)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidRequestURL.localizedDescription)
            case .success:
                XCTAssertFalse(true)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let fakeError = FakeResult.error
        let session = URLSessionFake(nil, nil, FakeResult.error)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.errorFromAPI(fakeError.errorDescription!).localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let fakeError = FakeResult.error
        let session = URLSessionFake(nil, nil, FakeResult.error)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.errorFromAPI(fakeError.errorDescription!).localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackBadResponseWhenCurrencySessionResponseIsNil() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.badResponse.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackBadResponseWhenCurrencySessionResponseIsNil() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.badResponse.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackBadResponseWhenCurrencySessionResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResult.badResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.badResponseNumber("500").localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackBadResponseWhenCurrencySessionResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResult.badResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.badResponseNumber("500").localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let session = URLSessionFake(nil, FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.emptyData.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let session = URLSessionFake(nil, FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.emptyData.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResult.badData, FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.jsonDecodeFailed.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResult.badData, FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.jsonDecodeFailed.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesNamesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResult.getGoodData(.currencies), FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesNames { (result) in
            // Then
            switch result {
            case .success(let currenciesNames):
                XCTAssertEqual(currenciesNames.count, 168)
                XCTAssertEqual(currenciesNames["EUR"], "Euro")
                XCTAssertEqual(currenciesNames["USD"], "United States Dollar")
            case .failure(let error):
                XCTAssertNil(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetCurrenciesRatesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResult.getGoodData(.rates), FakeResult.goodResponse, nil)
        let currencyService = CurrencyService(session: session)
        // When
        currencyService.getCurrenciesRates { (result) in
            // Then
            switch result {
            case .success(let currenciesRates):
                XCTAssertEqual(currenciesRates.count, 168)
                XCTAssertEqual(currenciesRates["EUR"], 1)
                XCTAssertEqual(currenciesRates["USD"], 1.132394)
            case .failure(let error):
                XCTAssertNil(error)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCreateCurrenciesObjectsShouldReturnArrayOfCurrenciesWhenParamatersAreGood() {
        // Given
        let currencyService = CurrencyService(session: URLSessionFake(nil, nil, nil))
        // When
        let currencies = currencyService.createCurrenciesObjects(
            with: FakeResult.decodedCurrenciesNames,
            and: FakeResult.decodedCurrenciesRates
        )
        XCTAssertEqual(currencies[0].code, "EUR")
        XCTAssertEqual(currencies[0].name, "Euro")
        XCTAssertEqual(currencies[0].rate, 1)
        XCTAssertEqual(currencies[1].code, "USD")
        XCTAssertEqual(currencies[1].name, "United States Dollar")
        XCTAssertEqual(currencies[1].rate, 1.132394)
        XCTAssertEqual(currencies[2].code, "AFN")
        XCTAssertEqual(currencies[2].name, "Afghan Afghani")
        XCTAssertEqual(currencies[2].rate, 84.567006)
        XCTAssertEqual(currencies.last?.code, "AED")
        XCTAssertEqual(currencies.last?.name, "United Arab Emirates Dirham")
        XCTAssertEqual(currencies.last?.rate, 4.159274)
    }
    
    func testWhenCurrenciesNamesParamatersIsEmptyCreateCurrenciesObjectsShouldFillCurrenciesNamesWithTheirCode() {
        // Given
        let currencyService = CurrencyService(session: URLSessionFake(nil, nil, nil))
        // When
        let currencies = currencyService.createCurrenciesObjects(
            with: [:],
            and: FakeResult.decodedCurrenciesRates
        )
        XCTAssertEqual(currencies[0].code, "EUR")
        XCTAssertEqual(currencies[0].name, "EUR")
        XCTAssertEqual(currencies[0].rate, 1)
        XCTAssertEqual(currencies[1].code, "USD")
        XCTAssertEqual(currencies[1].name, "USD")
        XCTAssertEqual(currencies[1].rate, 1.132394)
        XCTAssertEqual(currencies[2].code, "AED")
        XCTAssertEqual(currencies[2].name, "AED")
        XCTAssertEqual(currencies[2].rate, 4.159274)
        XCTAssertEqual(currencies.last?.code, "AUD")
        XCTAssertEqual(currencies.last?.name, "AUD")
        XCTAssertEqual(currencies.last?.rate, 1.611895)
    }
}
