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
    // MARK: Properties
    
    /// Url of the API
    private let apiUrl = "https://translation.googleapis.com/language/translate/v2"
    
    /// Key to access the API
    private let apiKey = "AIzaSyDX07xWgK_IQRN3wXHFBopwycC9AzachOU"
    
    /// Source text that have to be translated
    private var sourceText = ""
    
    /// Text translated
    var translation = ""
    
    /// Language of the text to translate
    var sourceLanguage: Language = Language.list[0]
    
    /// Language in which the source text must be translated
    var targetLanguage: Language = Language.list[1]
    
    /// Arguments nesserary to request the API
    private var arguments: [String: String] {
        return [
            "q": sourceText,
            "source": sourceLanguage.code,
            "target": targetLanguage.code,
            "key": apiKey
        ]
    }
    
    /// Session configuration
    var session = URLSession(configuration: .default)
    
    /// Task to execute
    var task: URLSessionDataTask?
    
    // MARK: Singleton
    
    /// Unique instance of the class for singleton pattern
    static let shared = TranslationService()
    
    /// Private init for singleton pattern
    private init() {}
}

// MARK: - Methods

extension TranslationService {
    /**
     Fetch translation of a source text
     - Parameters:
        - sourceText: Text to translate
        - sourceLanguage: Language of the text to translate
        - targetLanguage: Language in which the source text must be translated
        - callback: closure wich return an optional Error
     */
    func getTranslation(sourceText: String, sourceLanguage: Language, targetLanguage: Language, callback: @escaping (Error?) -> Void) {
        self.sourceText = sourceText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        
        guard let url = createRequestURL(url: apiUrl, arguments: arguments) else {
            callback(NetworkError.invalidRequestURL)
            return
        }
        
        task?.cancel()
        print(url)
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let failure = self.getFailure(error, response, data) {
                    callback(failure)
                    return
                }
                
                guard let data = data, let translation = try? JSONDecoder().decode(TranslationResult.self, from: data) else {
                    callback(NetworkError.jsonDecodeFailed)
                    return
                }
                
                self.translation = translation.data.translations[0].translatedText
                callback(nil)
            }
        }
        task?.resume()
    }
}
