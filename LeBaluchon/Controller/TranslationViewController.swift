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
    //MARK: Properties
    
    /// Placeholder of the text view
    var placeholder = "Enter text here"
    
    /// Confirms that the user filled the source text view
    var sourceTextViewEdited = false
    
    // MARK: Outlets
    
    /// Button to change source language
    @IBOutlet weak var sourceLanguageButton: UIButton!
    
    /// Button to change target language
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    /// Text view to edit source text
    @IBOutlet weak var sourceTextView: UITextView!
    
    /// Text view to show translated text
    @IBOutlet weak var translatedTextView: UITextView!
    
    /// Translate button container
    @IBOutlet weak var translateButtonContainer: UIView!
    
    /// Translate button to run translate
    @IBOutlet weak var translateButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

// MARK: - Init

extension TranslationViewController {
    /// Custom init in the scene
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourceLanguageButton.setTitle(TranslationService.shared.sourceLanguage.name, for: .normal)
        targetLanguageButton.setTitle(TranslationService.shared.targetLanguage.name, for: .normal)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        translateButtonContainer.layer.cornerRadius = 10
    }
}

// MARK: - Methods

extension TranslationViewController {
    /**
     Ask to TranslationService to fetch translation of a source text
     - Parameters:
     - sourceText: Text to translate
     - sourceLanguage: Language of the text to translate
     - targetLanguage: Language in which the source text must be translated
     */
    func getTranslation(sourceText: String, sourceLanguage: Language, targetLanguage: Language) {
        translateButton.isHidden = true
        activityIndicator.isHidden = false
        TranslationService.shared.getTranslation(sourceText: sourceText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { (error) in
            if let error = error {
                print(error)
            } else {
                self.translatedTextView.text = TranslationService.shared.translation
            }
            self.translateButton.isHidden = false
            self.activityIndicator.isHidden = true
            self.translateButtonContainer.isHidden = true
        }
    }
    
    /// Reverse source and target language
    func reverseLanguages() {
        let lastSourceLanguage = TranslationService.shared.sourceLanguage
        
        TranslationService.shared.sourceLanguage = TranslationService.shared.targetLanguage
        TranslationService.shared.targetLanguage = lastSourceLanguage
        sourceLanguageButton.setTitle(TranslationService.shared.sourceLanguage.name, for: .normal)
        targetLanguageButton.setTitle(TranslationService.shared.targetLanguage.name, for: .normal)
    }
    
    /// Reverse languages when the button is tapped
    @IBAction func reverserButtonTapped(_ sender: UIButton) {
        reverseLanguages()
    }
    
    /// Run translation when the button is tapped
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        getTranslation(sourceText: sourceTextView.text, sourceLanguage: TranslationService.shared.sourceLanguage, targetLanguage: TranslationService.shared.targetLanguage)
    }
}

// MARK: - Segue

extension TranslationViewController {
    /// Preparation before going to Language scene
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToLanguage", let languageVC = segue.destination as? LanguageTableViewController, let sender = sender as? UIButton {
            languageVC.delegate = self
            languageVC.sender = sender
            if sender == sourceLanguageButton {
                languageVC.language = TranslationService.shared.sourceLanguage
            }
            else {
                languageVC.language = TranslationService.shared.targetLanguage
            }
        }
    }
    
    /// Go to Language scene when language button is tapped
    @IBAction func languageButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLanguage", sender: sender)
    }
}

// MARK: - UITextViewDelegate

extension TranslationViewController: UITextViewDelegate {
    /// Dismiss keyboard when leaving text view edition
    @objc func dismissKeyboard(_ sender: UITextView) {
        sourceTextView.resignFirstResponder()
    }
    
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
            getTranslation(sourceText: sourceTextView.text, sourceLanguage: TranslationService.shared.sourceLanguage, targetLanguage: TranslationService.shared.targetLanguage)
            return false
        }
        return true
    }
    
    /// Hide or show the translate button if the source text view is filled or not
    func textViewDidChange(_ textView: UITextView) {
        let trimmedSourceTextView = sourceTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedSourceTextView.isEmpty == false {
            translateButtonContainer.isHidden = false
            sourceTextViewEdited = true
        } else {
            translateButtonContainer.isHidden = true
            sourceTextViewEdited = false
        }
    }
}

// MARK: - LanguageTableViewControllerDelegate

extension TranslationViewController: LanguageTableViewControllerDelegate {
    /**
    Change the source or target language
     - Parameters:
         - language: The language selected
         - sender: The button to update
    */
    func changeLanguage(language: Language, sender: UIButton) {
        if sender == sourceLanguageButton {
            if TranslationService.shared.targetLanguage.code == language.code {
                reverseLanguages()
                return
            }
            TranslationService.shared.sourceLanguage = language
            sourceLanguageButton.setTitle(language.name, for: .normal)
        } else {
            if TranslationService.shared.sourceLanguage.code == language.code {
                reverseLanguages()
                return
            }
            TranslationService.shared.targetLanguage = language
            targetLanguageButton.setTitle(language.name, for: .normal)
        }
        
    }
}
