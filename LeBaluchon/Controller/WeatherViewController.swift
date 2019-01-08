//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by co5ta on 31/07/2018.
//  Copyright © 2018 Co5ta. All rights reserved.
//

import UIKit

/// Controller that manages the Weather scene
class WeatherViewController: UIViewController {

    // MARK: Outlets
    
    /// The current condition location
    @IBOutlet weak var locationLabel: UILabel!
    /// The current condition
    @IBOutlet weak var conditionLabel: UILabel!
    /// The current condition icon
    @IBOutlet weak var conditionImageView: UIImageView!
    /// The current temperature of the weather
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getForeCasts() {

    }

}
