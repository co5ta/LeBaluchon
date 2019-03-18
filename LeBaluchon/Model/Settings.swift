//
//  Settings.swift
//  LeBaluchon
//
//  Created by co5ta on 15/03/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

struct Settings {
    
    struct Translation {
        static var sourceLanguageDefault = Language.list[0]
        static var TargetLanguageDefault = Language.list[1]
        
        static var sourceLanguage: Language {
            get {
                guard let json = UserDefaults.standard.object(forKey: "sourceLanguage") as? Data
                    else {
                    return sourceLanguageDefault
                }
                guard let language = try? JSONDecoder().decode(Language.self, from: json) else {
                    return sourceLanguageDefault
                }
                return language
            }
            set {
                if let json = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(json, forKey: "sourceLanguage")
                }
            }
        }
        
        static var targetLanguage: Language {
            get {
                guard let json = UserDefaults.standard.object(forKey: "targetLanguage") as? Data else {
                    return TargetLanguageDefault
                }
                guard let language = try? JSONDecoder().decode(Language.self, from: json) else {
                    return TargetLanguageDefault
                }
                return language
            }
            set {
                if let json = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(json, forKey: "targetLanguage")
                }
            }
        }
    }
    
}
