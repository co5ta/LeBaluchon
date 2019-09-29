//
//  TranslationViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 31/07/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// Manages the Translation scene
class TranslationViewController: UIViewController {
    // MARK: Outlets
    
    /// Cancel button
    @IBOutlet weak var cancelButton: UIButton!
    
    /// Tab bar item
    @IBOutlet weak var translationTabBarItem: UITabBarItem!
    
    /// Button to change source language
    @IBOutlet weak var sourceLanguageButton: UIButton!
    
    /// Button to change target language
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    /// View which contains source and translated text
    @IBOutlet weak var textContainerBottom: NSLayoutConstraint!
    
    /// Text view to edit source text
    @IBOutlet weak var sourceTextView: UITextView!
    
    /// Text view to show translated text
    @IBOutlet weak var translatedTextView: UITextView!
    
    /// Translate button to run translate
    @IBOutlet weak var translateButton: UIButton!
    
    /// Activity indicator for translation request
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    /// Button to hide keyboard
    @IBOutlet weak var keyboardButton: UIButton!
    
    // MARK: Properties
    
    /// Placeholder of the text view
    var placeholder = "Enter text here"
    
    /// Confirms that the user filled the source text view
    var sourceTextViewEdited = false {
        didSet {
            cancelButton.isHidden = !sourceTextViewEdited
            translateButton.isHidden = !sourceTextViewEdited
        }
    }
}

// MARK: - Init

extension TranslationViewController {
    /// Custom init in the scene
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceLanguageButton.setTitle(Language.source.name, for: .normal)
        targetLanguageButton.setTitle(Language.target.name, for: .normal)
        
        let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 30)
        sourceTextView.textContainerInset = padding
        translatedTextView.textContainerInset = padding
        
        registerKeyboardNotifications()
    }
}

// MARK: - Methods

extension TranslationViewController {
    /// Ask to TranslationService to fetch translation of a source text
    func getTranslation() {
        toggleActivityIndicator(show: true)
        TranslationService.shared.sourceText = sourceTextView.text
        
        TranslationService.shared.getTranslation() { [weak self] (result) in
            switch result {
            case .failure(let error):
                self?.present(UIAlertController.alert(error), animated: true)
            case .success(let translation):
                self?.translatedTextView.text = translation
            }
            self?.toggleActivityIndicator(show: false)
            self?.sourceTextView.resignFirstResponder()
        }
    }
    
    /// Toggle activity indicator
    private func toggleActivityIndicator(show: Bool) {
        translateButton.isHidden = show
        activityIndicator.isHidden = !show
    }
    
    /// Reverse source and target language
    func reverseLanguages() {
        (Language.source, Language.target) = (Language.target, Language.source)
        sourceLanguageButton.setTitle(Language.source.name, for: .normal)
        targetLanguageButton.setTitle(Language.target.name, for: .normal)
    }
    
    /// Clean source text view
    func cleanSourceTextView() {
        sourceTextView.text = ""
        sourceTextViewEdited = false
        sourceTextView.becomeFirstResponder()
        translatedTextView.text = ""
    }
    
    /// Clean source text view when button is tapped
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cleanSourceTextView()
    }
    
    /// Reverse languages when button is tapped
    @IBAction func reverserButtonTapped(_ sender: UIButton) {
        reverseLanguages()
    }
    
    /// Run translation when button is tapped
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        getTranslation()
    }
}

// MARK: - Segue

extension TranslationViewController {
    /// Preparation before going to Language scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToLanguage" else { return }
        guard let languageVC = segue.destination as? LanguageTableViewController, let sender = sender as? UIButton else { return }
        languageVC.delegate = self
        languageVC.sender = sender
        languageVC.language = (sender == sourceLanguageButton) ? Language.source : Language.target
    }
    
    /// Go to Language scene when language button is tapped
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLanguage", sender: sender)
    }
}

// MARK: - Keyboard notifications

extension TranslationViewController {
    /// Add notification to know when keyboard appear and disappear
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    /// Called when keyboard appeared
    @objc func keyboardDidShow(_ notification: NSNotification) {
        keyboardButton.isHidden = false
        if sourceTextViewEdited { translateButton.isHidden = false }
        guard let info = notification.userInfo else { return }
        guard let keyboardFrameValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let tabBarHeight = navigationController?.tabBarController?.tabBar.frame.height else {return}
        resizeTextContainer(value: keyboardFrameValue.cgRectValue.size.height - tabBarHeight)
    }
    
    /// Called when keyboard will disappear
    @objc func keyboardWillHide(_ notification: NSNotification) {
        keyboardButton.isHidden = true
        translateButton.isHidden = true
        resizeTextContainer(value: 0)
    }
    
    /// Resize the text views with an animation to prevent them of being hided by the keyboard
    private func resizeTextContainer(value: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: { [weak self] in
            self?.textContainerBottom.constant = value
            self?.view.layoutIfNeeded()
        })
    }
    
    /// Hide keyboard on touch
    @IBAction func keyboardButtonTapped(_ sender: UIButton) {
        sourceTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate

extension TranslationViewController: UITextViewDelegate {
    /// Remove the placeholder before editing text
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if sourceTextView.text == placeholder && sourceTextViewEdited == false {
            sourceTextView.text = ""
        }
        return true
    }
    
    /// Put the placeholder in text view if it is empty
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if sourceTextView.text.isEmpty {
            sourceTextView.text = placeholder
        }
        return true
    }
    
    /// Run the translation when return key is tapped
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sourceTextView.resignFirstResponder()
            getTranslation()
            return false
        }
        return true
    }
    
    /// Hide or show the translate button if the source text view is filled or not
    func textViewDidChange(_ textView: UITextView) {
        let trimmedSourceTextView = sourceTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        sourceTextViewEdited = trimmedSourceTextView.isEmpty ? false: true
    }
}

// MARK: - LanguageTableViewControllerDelegate

extension TranslationViewController: LanguageTableViewControllerDelegate {
    /// Select a new language
    func selectLanguage(language: Language, sender: UIButton) {
        if sender == sourceLanguageButton {
            if Language.target == language {
                reverseLanguages()
                return
            }
            Language.source = language
            sourceLanguageButton.setTitle(language.name, for: .normal)
        } else {
            if Language.source == language {
                reverseLanguages()
                return
            }
            Language.target = language
            targetLanguageButton.setTitle(language.name, for: .normal)
        }
    }
}
