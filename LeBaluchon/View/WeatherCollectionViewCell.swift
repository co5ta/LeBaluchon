//
//  WeatherCollectionViewCell.swift
//  LeBaluchon
//
//  Created by co5ta on 01/02/2019.
//  Copyright © 2019 Co5ta. All rights reserved.
//

import UIKit

/// Custom CollectionViewCell for weather
class WeatherCollectionViewCell: UICollectionViewCell {
    // MARK: Outlets
    
    /// The weather condition location
    @IBOutlet weak var locationLabel: UILabel!
    
    /// The weather condition description
    @IBOutlet weak var conditionLabel: UILabel!
    
    /// The weather condition icon
    @IBOutlet weak var conditionImageView: UIImageView!
    
    /// The temperature
    @IBOutlet weak var temperatureLabel: UILabel!
}

// MARK: - Methods

extension WeatherCollectionViewCell {
    /// Configure the cell with data
    func configure(_ weatherCondition: WeatherCondition) {
        locationLabel.text = weatherCondition.location
        conditionLabel.text = weatherCondition.condition.description
        conditionImageView.image = UIImage(named: weatherCondition.condition.icon)
        temperatureLabel.text = weatherCondition.celciusTemperatures
    }
}
