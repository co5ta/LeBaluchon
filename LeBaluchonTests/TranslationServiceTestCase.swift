//
//  TranslationServiceTestCase.swift
//  LeBaluchonTests
//
//  Created by co5ta on 07/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import XCTest
@testable import LeBaluchon

class TranslationServiceTestCase: XCTestCase {
    let expectation = XCTestExpectation(description: "Wait for queue change")
    
    func testGetTranslationShouldCallbackInvalidRequestUrlIfApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let translationService = TranslationService(session: session, apiUrl: "ç")
        
        //When
        translationService.getTranslation { (error) in
            //Then
            XCTAssertEqual(error, NetworkError.invalidRequestURL)
            XCTAssert(translationService.translation.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackErrorFromApiIfTaskReturnsError() {
        // Given
        let session = URLSessionFake(nil, nil, ServiceFakeData.error)
        let translationService = TranslationService(session: session)
        
        // When
        translationService.getTranslation { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.errorFromAPI)
            XCTAssert(translationService.translation.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackBadResponseIfResponseIsNot200() {
        // Given
        let session = URLSessionFake(nil, ServiceFakeData.badResponse, nil)
        let translationService = TranslationService(session: session)
        
        //When
        translationService.getTranslation { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.badResponse)
            XCTAssert(translationService.translation.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackEmptyDataIfRequestReturnsEmptyData() {
        // Given
        let session = URLSessionFake(nil, ServiceFakeData.goodResponse, nil)
        let translationService = TranslationService(session: session)
        
        //When
        translationService.getTranslation { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.emptyData)
            XCTAssert(translationService.translation.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackJsonDecodeFailedIRequestReturnsBadData() {
        // Given
        let session = URLSessionFake(ServiceFakeData.badData, ServiceFakeData.goodResponse, nil)
        let translationService = TranslationService(session: session)
        
        //When
        translationService.getTranslation { (error) in
            // Then
            XCTAssertEqual(error, NetworkError.jsonDecodeFailed)
            XCTAssert(translationService.translation.isEmpty)
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackNilErrorIfRequestReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(ServiceFakeData.goodTranslationData, ServiceFakeData.goodResponse, nil)
        let translationService = TranslationService(session: session)
        
        //When
        translationService.getTranslation { (error) in
            // Then
            XCTAssertNil(error)
            XCTAssertEqual(translationService.translation, "You're welcome")
            XCTAssertEqual(Language.sourceLanguage.code, "fr")
            XCTAssertEqual(Language.targetLanguage.code, "en")
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
