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
    
    /// All available currencies
    var currencies = [Currency]()
    /// Exchange rates grouped by relative currencies
    var rates: RelativeRates?
    
    // MARK: - Outlets
    
    /// Value to convert
    @IBOutlet weak var valueToConvertTextField: UITextField!
    /// Value converted
    @IBOutlet weak var valueConvertedTextField: UITextField!
    /// Currency of the value to convert
    @IBOutlet weak var firstCurrencyPickerView: UIPickerView!
    /// Currency of the value converted
    @IBOutlet weak var secondCurrencyPickerView: UIPickerView!
    /// Button to launch conversion
    @IBOutlet weak var convertButton: UIButton!
}

// MARK: - Keyboard

extension CurrencyViewController: UITextFieldDelegate {
    /// Dismiss keyboard when user leave a text field
    func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        valueToConvertTextField.resignFirstResponder()
    }
}

// MARK: - Setup

extension CurrencyViewController {
    /// Setup the scene before first display
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueToConvertTextField.delegate = self
        
        firstCurrencyPickerView.dataSource = self
        firstCurrencyPickerView.delegate = self
        
        secondCurrencyPickerView.dataSource = self
        secondCurrencyPickerView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        getCurrencies()
        getRates()
    }
    
    /// Fetch currencies for pickerViews
    func getCurrencies() {
        CurrencyService.shared.getCurrencies(callback: { (success, data) in
            DispatchQueue.main.async {
                if success, let data = data {
                    self.currencies = data
                    self.reloadPickerViews()
                } else {
                    // Display an error message
                }
            }
        })
    }
    
    /// Fetch latest rates relative EUR currency
    func getRates() {
        CurrencyService.shared.getRates() { (success, data) in
            DispatchQueue.main.sync {
                if success, let data = data {
                    self.rates = data
                } else {
                    // Display error message
                }
            }
        }
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
        return currency.name
    }
    
    /// Reload data in the pickerviews
    fileprivate func reloadPickerViews() {
        firstCurrencyPickerView.reloadComponent(0)
        secondCurrencyPickerView.reloadComponent(0)
        secondCurrencyPickerView.selectRow(1, inComponent: 0, animated: false)
    }
}

/// MARK: - Currency conversion

extension CurrencyViewController {
    /// Launch currency conversion
    @IBAction func convertButtonTapped(_ sender: UIButton) {
        convert()
    }
    
    /// Convert a value from a currency to another
    func convert() {
        let sourceCurrency = currencies[firstCurrencyPickerView.selectedRow(inComponent: 0)]
        let targetCurrency = currencies[secondCurrencyPickerView.selectedRow(inComponent: 0)]
        
        guard let sourceValue = valueToConvertTextField.text else {
            print("There is no value to convert")
            return
        }
        
        guard let sourceCurrencyRate = rates?.rates[sourceCurrency.code] else {
            print("Source currency rate not found")
            return
        }
        
        guard let targetCurrencyRate = rates?.rates[targetCurrency.code] else {
            print("Target currency rate not found")
            return
        }
        
        let euroValue = (sourceValue as NSString).floatValue / sourceCurrencyRate
        
        let targetValue = euroValue * targetCurrencyRate
        valueConvertedTextField.text = String(targetValue)
    }
    
}

