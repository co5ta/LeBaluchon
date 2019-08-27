//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 31/07/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// Controller that manages the Currency scene
class CurrencyViewController: UIViewController {
    // MARK: Properties
    let currencyService = CurrencyService.shared
    
    // MARK: Outlets
    
    /// Value to convert
    @IBOutlet weak var sourceValueTextField: UITextField!
    
    /// Value converted
    @IBOutlet weak var targetValueTextField: UITextField!
    
    /// ISO code of the value to convert
    @IBOutlet weak var sourceCurrencyLabel: UILabel!
    
    /// ISO code of the value converted
    @IBOutlet weak var targetCurrencyLabel: UILabel!
    
    /// Currency of the value to convert
    @IBOutlet weak var sourceCurrencyPickerView: UIPickerView!
    
    /// Currency of the value converted
    @IBOutlet weak var targetCurrencyPickerView: UIPickerView!
}

// MARK: - Keyboard

extension CurrencyViewController: UITextFieldDelegate {
    /// Dismiss keyboard when user leave a text field
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        sourceValueTextField.resignFirstResponder()
    }
}

// MARK: - Setup

extension CurrencyViewController {
    /// Setup the scene before first display
    override func viewDidLoad() {
        super.viewDidLoad()
        sourceValueTextField.delegate = self
        
        sourceCurrencyPickerView.dataSource = self
        sourceCurrencyPickerView.delegate = self
        
        targetCurrencyPickerView.dataSource = self
        targetCurrencyPickerView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        getCurrencies()
    }
}

// MARK: - Requests

extension CurrencyViewController {
    /// Fetch currencies for pickerViews
    func getCurrencies() {
        currencyService.getCurrencies(callback: { error in
            if let error = error {
                self.present(NetworkError.alert(error), animated: true)
            } else {
                self.reloadPickerViews()
                self.getRates()
            }
        })
    }
    
    func presentAlert(_ error: Error) {
        
    }
    
    /// Fetch currencies values
    func getRates() {
        currencyService.getRates { (error) in
            if let error = error {
                self.present(NetworkError.alert(error), animated: true)
            } else {
                self.sourceValueTextField.text = "1"
                self.convert()
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
        return currencyService.currencies.count
    }
    
    /// Give the content of a row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = currencyService.currencies[row]
        return currency.name
    }
    
    /// Launch actions each time selected row changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateCurrencyLabel(pickerView: pickerView, row: row)
        convert()
    }
    
    /// Update the short name of the currency near the value
    private func updateCurrencyLabel(pickerView: UIPickerView, row: Int) {
        let currency = currencyService.currencies[row]
        if pickerView == sourceCurrencyPickerView {
            sourceCurrencyLabel.text = currency.code
        } else {
            targetCurrencyLabel.text = currency.code
        }
    }
    
    /// Reload data in the pickerviews
    fileprivate func reloadPickerViews() {
        sourceCurrencyPickerView.reloadComponent(0)
        targetCurrencyPickerView.reloadComponent(0)
        targetCurrencyPickerView.selectRow(1, inComponent: 0, animated: false)
    }
    
    ///  Invert currencies
    @IBAction func interchangerButtonTaped(_ sender: Any) {
        let currentSourceCurrency = sourceCurrencyPickerView.selectedRow(inComponent: 0)
        let currentTargetCurrency = targetCurrencyPickerView.selectedRow(inComponent: 0)
        
        sourceCurrencyPickerView.selectRow(currentTargetCurrency, inComponent: 0, animated: true)
        targetCurrencyPickerView.selectRow(currentSourceCurrency, inComponent: 0, animated: true)
        
        updateCurrencyLabel(pickerView: sourceCurrencyPickerView, row: currentTargetCurrency)
        updateCurrencyLabel(pickerView: targetCurrencyPickerView, row: currentSourceCurrency)
        
        convert()
    }
}

// MARK: - Currency conversion

extension CurrencyViewController {
    /// Convert a value from a currency to another
    func convert() {
        let sourceCurrency = currencyService.currencies[sourceCurrencyPickerView.selectedRow(inComponent: 0)]
        let targetCurrency = currencyService.currencies[targetCurrencyPickerView.selectedRow(inComponent: 0)]
        
        guard let sourceValue = sourceValueTextField.text else {
            print("There is no value to convert")
            return
        }
        
        guard let sourceCurrencyRate = currencyService.rates[sourceCurrency.code] else {
            print("Source currency rate not found")
            return
        }
        
        guard let targetCurrencyRate = currencyService.rates[targetCurrency.code] else {
            print("Target currency rate not found")
            return
        }
        
        let euroValue = (sourceValue as NSString).floatValue / sourceCurrencyRate
        
        let targetValue = euroValue * targetCurrencyRate
        if targetValue.truncatingRemainder(dividingBy: 1) == 0 {
            targetValueTextField.text = String(Int(targetValue))
        } else {
            targetValueTextField.text = String(targetValue)
        }
    }
    
    /// Launch conversion each time text field is edited
    @IBAction func sourceValueTextFieldEdited(_ sender: UITextField) {
        convert()
    }
}

