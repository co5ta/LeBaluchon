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
    
    /// Collection view listing weather for each city
    @IBOutlet weak var collectionView: UICollectionView!
}

extension WeatherViewController {
    // MARK: Setup
    
    /// Setup the scene before first display
    override func viewDidLoad() {
        super.viewDidLoad()
        getConditions()
    }
    
    /// Fetch currents weather conditions
    func getConditions() {
        WeatherService.shared.getConditions { (success, weather) in
            if success {
                self.collectionView.reloadData()
            } else {
               print("error getting conditions")
            }
        }
    }
}

extension WeatherViewController: UICollectionViewDataSource {
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherService.shared.cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        }
        
        let city = WeatherService.shared.cities[indexPath.row]
        cell.configure(city)
        
        return cell
    }
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
