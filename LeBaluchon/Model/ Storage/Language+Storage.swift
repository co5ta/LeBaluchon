//
//  Language+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 22/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

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
    
    /// Stored source language
    static var source: Language {
        get {
            let defaultValue = list[0]
            guard let data = UserDefaults.standard.data(forKey: StorageKey.languageSource) else { return defaultValue }
            guard let language = try? JSONDecoder().decode(Language.self, from: data) else { return defaultValue }
            return language
        }
        set {
            guard let json = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(json, forKey: StorageKey.languageSource)
        }
    }
    
    /// Stored target language
    static var target: Language {
        get {
            let defaultValue = list[1]
            guard let data = UserDefaults.standard.data(forKey: StorageKey.languageTarget) else { return defaultValue }
            guard let language = try? JSONDecoder().decode(Language.self, from: data) else { return defaultValue }
            return language
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(data, forKey: StorageKey.languageTarget)
        }
    }
}
