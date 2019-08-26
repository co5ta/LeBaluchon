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
    /// Get a translation of a text with an API
    func getTranslation(callback: @escaping (Result<String, NetworkError>) -> Void) {
        guard let url = createRequestURL(url: apiUrl, arguments: arguments) else {
            callback(.failure(NetworkError.invalidRequestURL))
            return
        }
        
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let badResult = self.getFailure(error, response, data) {
                    callback(.failure(badResult))
                    return
                }

                do {
                    let translationResult = try JSONDecoder().decode(TranslationResult.self, from: data!)
                    callback(.success(translationResult.data.translations[0].text))
                } catch {
                    callback(.failure(NetworkError.jsonDecodeFailed))
                }
            }
        }
        task?.resume()
    }
}
