//
//  Translation.swift
//  LeBaluchon
//
//  Created by co5ta on 19/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Contains the result of the request given by API
struct TranslationResult: Decodable {
    /// Data of the result
    var data: TranslationData
}

/// Data of the result
struct TranslationData: Decodable {
    /// Contains all translations given by the API
    var translations: [Translation]
}

/// Translation in one language
struct Translation: Decodable {
    /// The text translated
    var translatedText: String
}
