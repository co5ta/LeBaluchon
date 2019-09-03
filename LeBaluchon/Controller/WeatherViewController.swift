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
    
    /// Page controller to indicates current page and number of pages
    @IBOutlet weak var pageController: UIPageControl!
}

// MARK: - Setup

extension WeatherViewController {
    /// Setup the scene before first display
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeatherData()
    }
    
    private func loadWeatherData() {
        if WeatherCondition.needsUpdate {
            getConditions()
        } else {
            reloadCollectionView()
        }
    }
    
    /// Fetch currents weather conditions
    func getConditions() {
        WeatherService.shared.getConditions { (result) in
            switch result {
            case .failure(let error):
                self.present(NetworkError.alert(error), animated: true)
            case .success(let weatherConditions):
                WeatherCondition.list = weatherConditions
                self.reloadCollectionView()
            }
        }
    }
    
    private func reloadCollectionView() {
        self.collectionView.reloadData()
        self.pageController.numberOfPages = WeatherCondition.list.count
    }
    
    /// Update current page in page controller
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageController.currentPage = Int(x / collectionView.frame.width)
    }
}

// MARK: - UICollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    /// Give the number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeatherCondition.list.count
    }
    
    /// Give the content of an item
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as? WeatherCollectionViewCell else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        }
        
        let weatherCondition = WeatherCondition.list[indexPath.row]
        cell.configure(weatherCondition)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension WeatherViewController: UICollectionViewDelegateFlowLayout {
    /// Give the size of items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    /// Give the size of space between items
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
