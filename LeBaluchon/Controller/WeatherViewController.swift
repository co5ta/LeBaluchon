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
}

extension WeatherViewController {
    // MARK: - Setup
    
    /// Setup the scene before first display
    override func viewDidLoad() {
        super.viewDidLoad()
        getConditions()
    }
    
    /// Fetch currents weather conditions
    func getConditions() {
        WeatherService.shared.getConditions { (success, weather) in
            if success, let weather = weather {
                self.update(weather)
            } else {
               print("error getting conditions")
            }
        }
    }
    
    /// Update the screen with the last weather conditions
    func update(_ weather: Weather) {
        locationLabel.text = weather.placeName
        conditionLabel.text = weather.primaryCondition.description
        conditionImageView.image = UIImage(named: weather.primaryCondition.icon)
        temperatureLabel.text = weather.celciusTemperatures
    }
}
