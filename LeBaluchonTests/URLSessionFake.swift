//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by co5ta on 04/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Substitute URLSession for unit tests
class URLSessionFake: URLSession {
    /// Fake data
    var data: Data?
    
    /// Fake response
    var response: URLResponse?
    
    /// Fake potential error
    var error: Error?
    
    /// Custom init to receive fake data
    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    /// Simulate dataTask func
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        task.completionHandler = completionHandler
        task.dataFake = data
        task.responseFake = response
        task.errorFake = error
        return task
    }
}

/// Substitute URLSessionDataTask for unit tests
class URLSessionDataTaskFake: URLSessionDataTask {
    /// Fake data
    var dataFake: Data?
    
    /// Fake response
    var responseFake: URLResponse?
    
    /// Fake potential error
    var errorFake: Error?
    
    /// Callback
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    // Simulate resume func and execute callback
    override func resume() {
        completionHandler?(dataFake, responseFake, errorFake)
    }
}
