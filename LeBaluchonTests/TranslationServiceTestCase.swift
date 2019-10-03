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
    
    override func setUp() {
        Storage.shared = Storage.test
    }
    
    func testGetTranslationShouldCallbackInvalidRequestUrlIfApiUrlIsBad() {
        // Given
        let session = URLSessionFake(nil, nil, nil)
        let translationService = TranslationService(session: session, apiUrl: FakeResponseData.badApiUrl)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldCallbackErrorFromApiIfTaskReturnsError() {
        // Given
        let session = URLSessionFake(nil, nil, FakeResponseData.error)
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
        wait(for: [expectation], timeout: 0.1)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldCallbackBadResponseIfResponseIs500() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.badResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldCallbackEmptyDataIfRequestReturnsEmptyData() {
        // Given
        let session = URLSessionFake(nil, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldCallbackJsonDecodeFailedIRequestReturnsBadData() {
        // Given
        let session = URLSessionFake(FakeResponseData.badData, FakeResponseData.goodResponse, nil)
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
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testGetTranslationShouldCallbackNilErrorIfRequestReturnsGoodResponseAndData() {
        // Given
        Language.source = Language.list[0]
        Language.target = Language.list[1]
        let session = URLSessionFake(FakeResponseData.getGoodData(.translation), FakeResponseData.goodResponse, nil)
        let translationService = TranslationService(session: session)
        //When
        translationService.getTranslation { (result) in
            // Then
            switch result {
            case .success(let translation):
                XCTAssertEqual(Language.source.code, "fr")
                XCTAssertEqual(Language.target.code, "en")
                XCTAssertEqual(translation, "You're welcome")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.1)
    }
}
