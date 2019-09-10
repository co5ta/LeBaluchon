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
        if let apiUrl = apiUrl { self.apiUrl = apiUrl }
    }
    
    // MARK: Properties
    
    /// Session configuration
    private var session = URLSession(configuration: .default)
    
    /// Task to execute
    private var task: URLSessionDataTask?
    
    private var apiUrl = Config.Currency.apiUrl
    
    /// Source text that have to be translated
    var sourceText = ""
    
    /// necessary arguments to request the API
    private var arguments: [String: String] {
        return [
            "q": sourceText,
            "source": Language.source.code,
            "target": Language.target.code,
            "format": "text",
            "key": Config.Translation.apiKey
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
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let result = self?.handleResult(error, response, data, TranslationResult.self) else { return }
                switch result {
                case .failure(let error):
                    callback(.failure(error))
                case .success(let translationResult):
                    callback(.success(translationResult.data.translations[0].translatedText))
                }
            }
        }
        task?.resume()
    }
}
