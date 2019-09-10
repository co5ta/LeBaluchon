//
//  WeatherServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by co5ta on 06/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class WeatherServiceTestCase: XCTestCase {
    let expectation = XCTestExpectation(description: "Wait for queue change")
    
    func testGetConditionsShouldCallbackInvalidRequestUrlIfApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let weatherService = WeatherService(session: session, apiUrl: FakeResult.badApiUrl)
        //When
        weatherService.getConditions { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.invalidRequestURL.localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackErrorIfRequestReturnsError() {
        // Given
        let fakeError = FakeResult.error
        let session = URLSessionFake(nil, nil, fakeError)
        let weatherService = WeatherService(session: session)
        //When
        weatherService.getConditions { (result) in
            // Then
            if case .failure(let error) = result {
                XCTAssertEqual(error.localizedDescription, NetworkError.errorFromAPI(fakeError.errorDescription!).localizedDescription)
            } else {
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackBadResponseIfResponseIsNil() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let weatherService = WeatherService(session: session)
        //When
        weatherService.getConditions { (result) in
            // Then
            if case .failure(let error) = result {
                XCTAssertEqual(error.localizedDescription, NetworkError.badResponse.localizedDescription)
            } else {
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackBadResponseIfResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResult.badResponse, nil)
        let weatherService = WeatherService(session: session)
        //When
        weatherService.getConditions { (result) in
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
    
    func testGetConditionsShouldCallbackEmptyDataIfRequestReturnsEmptyData() {
        // Given
        let session = URLSessionFake(nil, FakeResult.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        //When
        weatherService.getConditions { (result) in
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
    
    func testGetConditionsShouldCallbackJsonDecodeFailedIfRequestReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResult.badData, FakeResult.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        //When
        weatherService.getConditions { (result) in
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
    
    func testGetConditionsShouldCallbackNilErrorIfRequestReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResult.getGoodData(.weather), FakeResult.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (result) in
            // Then
            switch result {
            case .success(let weather):
                WeatherCondition.list = weather
                XCTAssertEqual(WeatherCondition.list.count, 2)
                XCTAssertEqual(WeatherCondition.list[0].location, "New York")
                XCTAssertEqual(WeatherCondition.list[0].condition.description, "few clouds")
                XCTAssertEqual(WeatherCondition.list[0].condition.icon, "02n")
                XCTAssertEqual(WeatherCondition.list[0].celciusTemperatures, "-8° C")
                XCTAssertEqual(WeatherCondition.list[1].location, "Paris")
                XCTAssertEqual(WeatherCondition.list[1].condition.description, "heavy intensity rain")
                XCTAssertEqual(WeatherCondition.list[1].condition.icon, "10d")
                XCTAssertEqual(WeatherCondition.list[1].celciusTemperatures, "8° C")
            case .failure:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGivenLastUpdateWasMadeSinceOneHourOrMoreThenDataNeedsUpdate() {
        // Given
        let oneHourLessInterval = -3600.0
        // When
        WeatherCondition.lastUpdate = Date(timeInterval: oneHourLessInterval, since: Date())
        // Then
        XCTAssertTrue(WeatherCondition.needsUpdate)
    }
    
    func testGivenLastUpdateWasMadeSinceLessThanOneHourThenDataNeedsUpdate() {
        // Given
        let halfHourLessInterval = -1800.0
        // When
        WeatherCondition.lastUpdate = Date(timeInterval: halfHourLessInterval, since: Date())
        // Then
        XCTAssertFalse(WeatherCondition.needsUpdate)
    }
}
