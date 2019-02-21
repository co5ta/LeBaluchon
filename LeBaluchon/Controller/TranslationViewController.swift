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
    
    // MARK: Outlets
    
    /// Button to change source language
    @IBOutlet weak var sourceLanguageButton: UIButton!
    
    /// Button to change target language
    @IBOutlet weak var targetLanguageButton: UIButton!
    
    /// Text view to edit source text
    @IBOutlet weak var sourceTextView: UITextView!
    
    /// Text view to show translated text
    @IBOutlet weak var translatedTextView: UITextView!
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
        TranslationService.shared.getTranslation(sourceText: sourceText, sourceLanguage: sourceLanguage, targetLanguage: targetLanguage) { (error) in
            if let error = error {
                print(error)
            } else {
                self.translatedTextView.text = TranslationService.shared.translation
            }
        }
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
        if sourceTextView.text.isEmpty {
            sourceTextView.text = placeholder
        }
    }
    
    /// Toggles the text that serves as placeholder
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if sourceTextView.text == placeholder {
            sourceTextView.text = ""
        }
        return true
    }
    
    /// Run translation when return key is tapped
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sourceTextView.resignFirstResponder()
            getTranslation(sourceText: sourceTextView.text, sourceLanguage: TranslationService.shared.sourceLanguage, targetLanguage: TranslationService.shared.targetLanguage)
            return false
        }
        return true
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
            TranslationService.shared.sourceLanguage = language
            sourceLanguageButton.setTitle(language.name, for: .normal)
        } else {
            TranslationService.shared.targetLanguage = language
            targetLanguageButton.setTitle(language.name, for: .normal)
        }
        
    }
}
