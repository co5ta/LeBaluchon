//
//  Language+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 22/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

extension Language {
    /// Store source language
    static var sourceLanguage: Language {
        get {
            guard let json = UserDefaults.standard.object(forKey: StorageKey.sourceLanguage) as? Data, let language = try? JSONDecoder().decode(Language.self, from: json) else {
                return list[0]
            }
            return language
        }
        set {
            if let json = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(json, forKey: StorageKey.sourceLanguage)
            }
        }
    }
    
    /// Store target language
    static var targetLanguage: Language {
        get {
            guard let json = UserDefaults.standard.object(forKey: StorageKey.targetLanguage) as? Data, let language = try? JSONDecoder().decode(Language.self, from: json) else {
                return list[1]
            }
            return language
        }
        set {
            if let json = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(json, forKey: StorageKey.targetLanguage)
            }
        }
    }
}


extension Language {
    /// Available languages for translation
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
