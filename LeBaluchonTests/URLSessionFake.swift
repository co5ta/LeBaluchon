//
//  URLSessionFake.swift
//  LeBaluchonTests
//
//  Created by co5ta on 04/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

class URLSessionFake: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSessionDataTaskFake()
        
        task.completionHandler = completionHandler
        task.dataFake = data
        task.responseFake = response
        task.errorFake = error
        
        return task
    }
}

class URLSessionDataTaskFake: URLSessionDataTask {
    var dataFake: Data?
    var responseFake: URLResponse?
    var errorFake: Error?
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    override func resume() {
        completionHandler?(dataFake, responseFake, errorFake)
    }
    
    override func cancel() {}
}
