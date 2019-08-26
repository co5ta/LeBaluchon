//
//  Language+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 22/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

extension Language {
    /// Source language by default
    static let defaultSourceLanguage = list[0]
    
    /// Target language by default
    static let defaultTargetLanguage = list[1]
    
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

extension Language {
    /// Stored source language
    static var sourceLanguage: Language {
        get {
            guard let data = UserDefaults.standard.data(forKey: StorageKey.sourceLanguage) else { return defaultSourceLanguage }
            guard let language = try? JSONDecoder().decode(Language.self, from: data) else { return defaultSourceLanguage }
            return language
        }
        set {
            guard let json = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(json, forKey: StorageKey.sourceLanguage)
        }
    }
    
    /// Stored target language
    static var targetLanguage: Language {
        get {
            guard let data = UserDefaults.standard.data(forKey: StorageKey.targetLanguage) else { return defaultTargetLanguage }
            guard let language = try? JSONDecoder().decode(Language.self, from: data) else { return defaultTargetLanguage }
            return language
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: StorageKey.targetLanguage)
        }
    }
}
