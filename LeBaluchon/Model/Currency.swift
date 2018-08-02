//
//  Currency.swift
//  LeBaluchon
//
//  Created by co5ta on 01/08/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import Foundation

class Currency {
    static var all : [[String: Any]] {
        guard let url = Bundle.main.url(forResource: "currencies", withExtension: "json") else {
            print("json not found")
            return [[:]]
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("error with json data recuperation")
            return [[:]]
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            print("error with json data serialization")
            return [[:]]
        }
        
        guard let jsonArray = json as? [[String: Any]] else {
            print("error with cast json data to array")
            return [[:]]
        }
        
        print(jsonArray)
        
        return jsonArray
    }
}
