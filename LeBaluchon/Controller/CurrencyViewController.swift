//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 31/07/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// A Controller that manages the Currency scene
class CurrencyViewController: UIViewController {
    // MARK: - Properties
    
    /// An array with all available currencies
    let currencies = Currency.all
    
    // MARK: - Outlets
    
    /// Value to convert
    @IBOutlet weak var valueToConvertTextField: UITextField!
    /// Value converted
    @IBOutlet weak var valueConvertedTextField: UITextField!
    /// Currency of the value to convert
    @IBOutlet weak var firstCurrencyPickerView: UIPickerView!
    /// Currency of the value converted
    @IBOutlet weak var secondCurrencyPickerView: UIPickerView!
}

// MARK: - Setup

extension CurrencyViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueToConvertTextField.delegate = self
        valueConvertedTextField.delegate = self
        
        firstCurrencyPickerView.dataSource = self
        firstCurrencyPickerView.delegate = self
        
        secondCurrencyPickerView.dataSource = self
        secondCurrencyPickerView.delegate = self
        secondCurrencyPickerView.selectRow(1, inComponent: 0, animated: false)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - PickerView

extension CurrencyViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    /// Give the number of components in the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /// Give the number of rows in the a pickerView's component
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    /// Give the title for a row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencies[row]
        guard let currencyName = currency["name"] as? String, let currencyCode = currency["code"] as? String else {
            print("currency name or curreny code not found")
            return nil
        }
        return "\(currencyCode) - \(currencyName)"
    }
}

// MARK: - Keyboard

extension CurrencyViewController: UITextFieldDelegate {
    func hideKeyboard(_ sender: UITapGestureRecognizer) {
        valueToConvertTextField.resignFirstResponder()
        valueConvertedTextField.resignFirstResponder()
    }
}
