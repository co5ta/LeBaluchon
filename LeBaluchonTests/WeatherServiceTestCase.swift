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
        let weatherService = WeatherService(session: session, apiUrl: "ç")
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.invalidRequestURL)
            XCTAssert(weatherService.cities.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackErrorIfRequestReturnsError() {
        // Given
        let session = URLSessionFake(nil, nil, ServiceFakeData.error)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.errorFromAPI)
            XCTAssert(weatherService.cities.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackBadResponseIfResponseIsNot200() {
        // Given
        let session = URLSessionFake(nil, ServiceFakeData.badResponse, nil)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.badResponse)
            XCTAssert(weatherService.cities.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackEmptyDataIfRequestReturnsEmptyData() {
        // Given
        let session = URLSessionFake(nil, ServiceFakeData.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.emptyData)
            XCTAssert(weatherService.cities.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackJsonDecodeFailedIRequestReturnsBadData() {
        // Given
        let session = URLSessionFake(ServiceFakeData.badData, ServiceFakeData.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.jsonDecodeFailed)
            XCTAssert(weatherService.cities.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetConditionsShouldCallbackNilErrorIfRequestReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(ServiceFakeData.goodWeatherData, ServiceFakeData.goodResponse, nil)
        let weatherService = WeatherService(session: session)
        
        //When
        weatherService.getConditions { (error) in
            // Then
            XCTAssertNil(error)
            XCTAssertEqual(weatherService.cities.count, 2)
            XCTAssertEqual(weatherService.cities[0].name, "New York")
            XCTAssertEqual(weatherService.cities[0].primaryCondition.description, "few clouds")
            XCTAssertEqual(weatherService.cities[0].primaryCondition.icon, "02n")
            XCTAssertEqual(weatherService.cities[0].celciusTemperatures, "-8° C")
            XCTAssertEqual(weatherService.cities[1].name, "Paris")
            XCTAssertEqual(weatherService.cities[1].primaryCondition.description, "heavy intensity rain")
            XCTAssertEqual(weatherService.cities[1].primaryCondition.icon, "10d")
            XCTAssertEqual(weatherService.cities[1].celciusTemperatures, "8° C")
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
