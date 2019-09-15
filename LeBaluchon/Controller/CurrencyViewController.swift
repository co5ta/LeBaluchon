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
        sourceValueTextField.text = "1"
        setUpGestures()
        setUpDelegates()
        loadCurrencies()
    }
    
    private func setUpDelegates() {
        sourceValueTextField.delegate = self
        sourceCurrencyPickerView.dataSource = self
        sourceCurrencyPickerView.delegate = self
        targetCurrencyPickerView.dataSource = self
        targetCurrencyPickerView.delegate = self
    }
    
    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func loadCurrencies() {
        getCurrencies()
        // Currency.needsUpdate ? getCurrencies() : reloadPickerViews()
    }
}

// MARK: - Requests

extension CurrencyViewController {
    /// Fetch currencies for pickerViews
    func getCurrencies() {
        
        var currenciesNames = [String: String]()
        var currenciesRates = [String: Float]()
        let group = DispatchGroup()
        
        group.enter()
        CurrencyService.shared.getCurrenciesNames { [weak self] (result) in
            switch result {
            case .success(let namesData):
                currenciesNames = namesData
            case .failure(let error):
                self?.present(UIAlertController.alert(error), animated: true)
            }
            group.leave()
        }
        
        group.enter()
        CurrencyService.shared.getCurrenciesRates { [weak self] (result) in
            switch result {
            case .success(let ratesData):
                currenciesRates = ratesData
            case .failure(let error):
                self?.present(UIAlertController.alert(error), animated: true)
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            Currency.list = CurrencyService.shared.createCurrenciesObjects(with: currenciesNames, and: currenciesRates)
            self?.reloadPickerViews()
        }
    }
    
    private func toggleLoading(show: Bool) {
        
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
        return Currency.list.count
    }
    
    /// Give the content of a row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let currency = Currency.list[row]
        return currency.name
    }
    
    /// Launch actions each time selected row changes
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateCurrencyLabel(pickerView: pickerView, row: row)
        convert()
    }
    
    /// Update the short name of the currency near the value
    private func updateCurrencyLabel(pickerView: UIPickerView, row: Int) {
        let currency = Currency.list[row]
        if pickerView == sourceCurrencyPickerView {
            sourceCurrencyLabel.text = currency.code
            Currency.sourceInUse = row
        } else {
            targetCurrencyLabel.text = currency.code
            Currency.targetInUse = row
        }
    }
    
    /// Reload data in the pickerviews
    private func reloadPickerViews() {
        sourceCurrencyPickerView.reloadComponent(0)
        targetCurrencyPickerView.reloadComponent(0)
        showSelectedRows()
        convert()
    }
    
    private func showSelectedRows() {
        var targetIndex = Currency.targetInUse
        if (targetIndex == 0 && Currency.sourceInUse == 0) {
            targetIndex = 1
        }
        sourceCurrencyPickerView.selectRow(Currency.sourceInUse, inComponent: 0, animated: false)
        targetCurrencyPickerView.selectRow(targetIndex, inComponent: 0, animated: false)
        updateCurrencyLabel(pickerView: sourceCurrencyPickerView, row: Currency.sourceInUse)
        updateCurrencyLabel(pickerView: targetCurrencyPickerView, row: targetIndex)
    }
    
    ///  Invert currencies
    @IBAction func exchangeButtonTaped(_ sender: Any) {
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
        let sourceCurrency = Currency.list[sourceCurrencyPickerView.selectedRow(inComponent: 0)]
        let targetCurrency = Currency.list[targetCurrencyPickerView.selectedRow(inComponent: 0)]
        
        guard let sourceValue = sourceValueTextField.text else { return }
        let euroValue = (sourceValue as NSString).floatValue / sourceCurrency.rate
        
        let targetValue = euroValue * targetCurrency.rate
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

