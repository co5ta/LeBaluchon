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
        let translationService = TranslationService(session: session, apiUrl: FakeResult.badApiUrl)
        // When
        translationService.getTranslation { (result) in
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
    
    func testGetTranslationShouldCallbackErrorFromApiIfTaskReturnsError() {
        // Given
        let session = URLSessionFake(nil, nil, FakeResult.error)
        let translationService = TranslationService(session: session)
        // When
        translationService.getTranslation { (result) in
            // Then
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.errorFromAPI("A fake error occured").localizedDescription)
            case .success:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetTranslationShouldCallbackBadResponseIfResponseIsNil() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
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
    
    func testGetTranslationShouldCallbackBadResponseIfResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResult.badResponse, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
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
    
    func testGetTranslationShouldCallbackEmptyDataIfRequestReturnsEmptyData() {
        // Given
        let session = URLSessionFake(nil, FakeResult.goodResponse, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
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
    
    func testGetTranslationShouldCallbackJsonDecodeFailedIRequestReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResult.badData, FakeResult.goodResponse, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
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
    
    func testGetTranslationShouldCallbackNilErrorIfRequestReturnsGoodResponseAndData() {
        // Given
        let session = URLSessionFake(FakeResult.getGoodData(.translation), FakeResult.goodResponse, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertEqual(translation, "You're welcome")
            case .failure:
                XCTFail()
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
