//
//  Currency+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 28/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

extension Currency {
    static var needsUpdate: Bool {
        if let lastUpdate = Currency.lastUpdate, Calendar.current.isDateInToday(lastUpdate) {
            return false
        } else {
            return true
        }
    }
    static var lastUpdate: Date? {
        get {
            let date = UserDefaults.standard.object(forKey: StorageKey.currenciesLastUpdate) as? Date
            return date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: StorageKey.currenciesLastUpdate)
        }
    }
     
    static var list: [Currency] {
        get {
            guard let currenciesData = UserDefaults.standard.data(forKey: StorageKey.currenciesList) else { return [] }
            guard let currencies = try? JSONDecoder().decode([Currency].self, from: currenciesData) else { return [] }
            return currencies
        }
        set {
            guard let currenciesData = try? JSONEncoder().encode(newValue) else { return }
            UserDefaults.standard.set(currenciesData, forKey: StorageKey.currenciesList)
            lastUpdate = Date()
        }
    }
    
    static var sourceIndex: Int {
        get { return UserDefaults.standard.integer(forKey: StorageKey.currencySourceIndex) }
        set { UserDefaults.standard.set(newValue, forKey: StorageKey.currencySourceIndex) }
    }
    
    static var targetIndex: Int {
        get { return UserDefaults.standard.integer(forKey: StorageKey.currencyTargetIndex) }
        set { UserDefaults.standard.set(newValue, forKey: StorageKey.currencyTargetIndex) }
    }
}
