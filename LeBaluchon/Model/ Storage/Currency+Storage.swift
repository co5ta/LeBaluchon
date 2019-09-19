//
//  Currency+Storage.swift
//  LeBaluchon
//
//  Created by co5ta on 28/08/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation

extension Currency {
    /// Return true if last update time is superior to update interval value
    static var needsUpdate: Bool {
        guard let lastUpdate = lastUpdate else { return true }
        let difference = Calendar.current.dateComponents([.hour, .minute], from: lastUpdate, to: Date())
        guard let hour = difference.hour, hour < Config.updateInterval else { return true }
        return false
    }
    
    /// Date of the last update
    static var lastUpdate: Date? {
        get { return Storage.shared.object(forKey: Storage.currenciesLastUpdate) as? Date }
        set { Storage.shared.set(newValue, forKey: Storage.currenciesLastUpdate) }
    }
    
    /// Stored currencies data
    static var list: [Currency] {
        get {
            guard let currenciesData = Storage.shared.data(forKey: Storage.currencies) else { return [] }
            guard let currencies = try? JSONDecoder().decode([Currency].self, from: currenciesData) else { return [] }
            return currencies
        }
        set {
            guard let currenciesData = try? JSONEncoder().encode(newValue) else { return }
            Storage.shared.set(currenciesData, forKey: Storage.currencies)
            lastUpdate = Date()
        }
    }
    
    /// Index of the source currency
    static var sourceInUse: Int {
        get { return Storage.shared.integer(forKey: Storage.currencySourceIndex) }
        set { Storage.shared.set(newValue, forKey: Storage.currencySourceIndex) }
    }
    
    /// Index of the target currency
    static var targetInUse: Int {
        get { return Storage.shared.integer(forKey: Storage.currencyTargetIndex) }
        set { Storage.shared.set(newValue, forKey: Storage.currencyTargetIndex) }
    }
}
