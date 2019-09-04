//
//  UIAlerctController+Alert.swift
//  LeBaluchon
//
//  Created by co5ta on 04/09/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    /// Prepare an alert to explain an error
    static func alert(_ networkError: NetworkError) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: networkError.localizedDescription, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(confirmAction)
        return alert
    }
}
