//
//  LanguageTableViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 20/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import UIKit

/// Manages the Language scene
class LanguageTableViewController: UITableViewController {
    // MARK: Properties
    
    /// Language selected
    var language: Language?
    
    /// Button which brought here
    var sender: UIButton?
    
    /// Delegate which will update selected language in the application
    var delegate: LanguageTableViewControllerDelegate?
}

// MARK: - Table view data source

extension LanguageTableViewController {
    /// Number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Number of rows in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.list.count
    }
    
    /// Fills a cell with appropriate content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell", for: indexPath)

        let language = Language.list[indexPath.row]
        cell.textLabel?.text = language.name
        
        if let currentLanguage = self.language, currentLanguage.code == language.code {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    /// Validates the selection of a language
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        language = Language.list[indexPath.row]
        if let language = language, let sender = sender {
            delegate?.changeLanguage(language: language, sender: sender)
        }
        tableView.reloadData()
    }
}

// MARK: - Segue

extension LanguageTableViewController {
    // Dismiss the scene
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Protocol

/// Defines method to manage language selection
protocol LanguageTableViewControllerDelegate {
    /// Change the source or target language
    func changeLanguage(language: Language, sender: UIButton)
}
