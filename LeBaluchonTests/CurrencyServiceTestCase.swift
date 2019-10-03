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
    
    override func setUp() {
        Storage.shared = Storage.test
    }
    
    func testGetCurrenciesNamesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: FakeResponseData.badApiUrl)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackInvalidRequestURLWhenApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let currencyService = CurrencyService(session: session, apiUrl: FakeResponseData.badApiUrl)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesNamesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let fakeError = FakeResponseData.error
        let session = URLSessionFake(nil, nil, FakeResponseData.error)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackErrorFromAPIWhenCurrencySessionReturnsError() {
        // Given
        let fakeError = FakeResponseData.error
        let session = URLSessionFake(nil, nil, FakeResponseData.error)
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
        wait(for: [expectation], timeout: 0.1)
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
        wait(for: [expectation], timeout: 0.1)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesNamesShouldCallbackBadResponseWhenCurrencySessionResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.badResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackBadResponseWhenCurrencySessionResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.badResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesNamesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackEmptyDataWhenCurrencySessionReturnsNoData() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesNamesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResponseData.badData, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackJsonDecodeFailedWhenCurrencySessionReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResponseData.badData, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesNamesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResponseData.getGoodData(.currencies), FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetCurrenciesRatesShouldCallbackNilWhenCurrencySessionReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResponseData.getGoodData(.rates), FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testCreateCurrenciesObjectsShouldReturnArrayOfCurrenciesWhenParamatersAreGood() {
        // Given
        let currencyService = CurrencyService(session: URLSessionFake(nil, nil, nil))
        // When
        Currency.list = currencyService.createCurrenciesObjects(
            with: FakeDecodedData.currenciesNames,
            and: FakeDecodedData.currenciesRates
        )
        // Then
        XCTAssertEqual(Currency.list[0].code, "EUR")
        XCTAssertEqual(Currency.list[0].name, "Euro")
        XCTAssertEqual(Currency.list[0].rate, 1)
        XCTAssertEqual(Currency.list[1].code, "USD")
        XCTAssertEqual(Currency.list[1].name, "United States Dollar")
        XCTAssertEqual(Currency.list[1].rate, 1.132394)
        XCTAssertEqual(Currency.list[2].code, "AFN")
        XCTAssertEqual(Currency.list[2].name, "Afghan Afghani")
        XCTAssertEqual(Currency.list[2].rate, 84.567006)
        XCTAssertEqual(Currency.list.last?.code, "ZWL")
        XCTAssertEqual(Currency.list.last?.name, "Zimbabwean Dollar")
        XCTAssertEqual(Currency.list.last?.rate, 365.03284)
    }
    
    func testGivenLastUpdateWasMadeSinceOneHourOrMoreThenDataNeedsUpdate() {
        // Given
        let oneHourLessInterval = -3600.0
        // When
        Currency.lastUpdate = Date(timeInterval: oneHourLessInterval, since: Date())
        // Then
        XCTAssertTrue(Currency.needsUpdate)
    }
    
    func testGivenLastUpdateWasMadeSinceLessThanOneHourThenDataNeedsUpdate() {
        // Given
        let halfHourLessInterval = -1800.0
        // When
        Currency.lastUpdate = Date(timeInterval: halfHourLessInterval, since: Date())
        // Then
        XCTAssertFalse(Currency.needsUpdate)
    }
    
    func testCurrencySourceInUse() {
        Currency.sourceInUse = 3
        XCTAssertEqual(Currency.sourceInUse, 3)
    }
    
    func testCurrencyTargetInUse() {
        Currency.targetInUse = 4
        XCTAssertEqual(Currency.targetInUse, 4)
    }
}
