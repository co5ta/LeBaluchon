//
//  Language.swift
//  LeBaluchon
//
//  Created by co5ta on 03/04/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

/// Representation of a language
struct Language: Codable {
    /// Name of the language
    let name: String
    /// Code of the language
    let code: String
}

// MARK: Data

extension Language {
    /// Array listing the languages available for translation
    static let list = [
        Language(name: "French", code: "fr"),
        Language(name: "English", code: "en"),
        Language(name: "German", code: "de"),
        Language(name: "Italian", code: "it"),
        Language(name: "Japanese", code: "ja"),
        Language(name: "Portuguese", code: "pt"),
        Language(name: "Spanish", code: "es"),
        ]
}

// MARK: Persistence

extension Language {
    /// Contains key values for languages storage
    enum Key: String {
        case source = "sourceLanguage"
        case target = "targetLanguage"
    }
    
    /// Store source language
    static var sourceLanguage: Language {
        get {
            guard let json = UserDefaults.standard.object(forKey: Language.Key.source.rawValue) as? Data, let language = try? JSONDecoder().decode(Language.self, from: json) else {
                return list[0]
            }
            return language
        }
        set {
            if let json = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(json, forKey: Language.Key.source.rawValue)
            }
        }
    }
    
    /// Store target language
    static var targetLanguage: Language {
        get {
            guard let json = UserDefaults.standard.object(forKey: Language.Key.target.rawValue) as? Data, let language = try? JSONDecoder().decode(Language.self, from: json) else {
                return list[1]
            }
            return language
        }
        set {
            if let json = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(json, forKey: Language.Key.target.rawValue)
            }
        }
    }
}
