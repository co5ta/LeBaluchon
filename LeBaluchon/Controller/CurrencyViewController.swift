//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 31/07/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    let currencies = Currency.all
    
    @IBOutlet weak var firstCurrencyPickerView: UIPickerView!
    @IBOutlet weak var secondCurrencyPickerView: UIPickerView!
}

extension CurrencyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstCurrencyPickerView.dataSource = self
        firstCurrencyPickerView.delegate = self
        secondCurrencyPickerView.dataSource = self
        secondCurrencyPickerView.delegate = self
    }
}

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencies[row]
        guard let currencyName = currency["name"] as? String, let currencyCode = currency["code"] as? String else {
            print("currency name or curreny code not found")
            return nil
        }
        return "\(currencyCode) - \(currencyName)"
    }
    
}
