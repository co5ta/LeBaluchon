//
//  TranslationService.swift
//  LeBaluchon
//
//  Created by co5ta on 19/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Class that fetch data from the translation API
class TranslationService: Service {
    // MARK: Singleton
    
    /// Unique instance of the class for singleton pattern
    static let shared = TranslationService()
    
    /// Private init for singleton pattern
    private init() {}
    
    // MARK: Dependency injection
    
    /// Custom session and apiUrl for tests
    init(session: URLSession, apiUrl: String? = nil) {
        self.session = session
        if let apiUrl = apiUrl {
            self.apiUrl = apiUrl
        }
    }
    
    // MARK: Properties
    
    /// Session configuration
    private var session = URLSession(configuration: .default)
    
    /// Task to execute
    private var task: URLSessionDataTask?
    
    /// Url of the API
    private var apiUrl = "https://translation.googleapis.com/language/translate/v2"
    
    /// Key to access the API
    private let apiKey = "AIzaSyDX07xWgK_IQRN3wXHFBopwycC9AzachOU"
    
    /// Source text that have to be translated
    var sourceText = ""
    
    /// necessary arguments to request the API
    private var arguments: [String: String] {
        return [
            "q": sourceText,
            "source": Language.sourceLanguage.code,
            "target": Language.targetLanguage.code,
            "key": apiKey
        ]
    }
}

// MARK: - Methods

extension TranslationService {
    /**
    Get a translation of a text with an API
     - parameter callback: closure to manage the result of the request
     - parameter result: text translated or error
    */
    func getTranslation(callback: @escaping (_ result: Result<String, NetworkError>) -> Void) {
        guard let url = createRequestURL(url: apiUrl, arguments: arguments) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                switch self.handleResult(error, response, data) {
                case.failure(let error):
                    callback(.failure(error))
                case .success(let data):
                    callback(self.decode(data))
                }
            }
        }
        task?.resume()
    }
    
    /**
     Decode data from the API
     - parameter data: Data to decode
     - returns: Data decoded or error
     */
    func decode(_ data: Data) -> Result<String, NetworkError> {
        do {
            let translationResult = try JSONDecoder().decode(TranslationResult.self, from: data)
            return .success(translationResult.data.translations[0].translatedText)
        } catch {
           return .failure(NetworkError.jsonDecodeFailed)
        }
    }
}
