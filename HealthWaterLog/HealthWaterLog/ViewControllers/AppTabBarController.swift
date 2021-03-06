//
//  AppTabBarController.swift
//  HealthWaterLog
//
//  Created by Jessie Pease on 5/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {
    let coreDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coreDataManager.start() { [weak self] in
            self?.configureViewControllers()
        }
    }
    
    func configureViewControllers() {
        let trackWaterViewModel = TrackWaterViewModel(dataStore: coreDataManager.healthWaterLogDataController, userPreferenceManager: UserPreferenceManager.shared)
        
        let trackWaterViewController = TrackWaterViewController(viewModel:trackWaterViewModel)
                
        trackWaterViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let visualizeWaterIntakeViewModel = VisualizeWaterIntakeViewModel(dataStore: coreDataManager.healthWaterLogDataController, userPreferenceManager: UserPreferenceManager.shared)
        let visualizeWaterIntakeViewController = VisualizeWaterIntakeViewController(viewModel: visualizeWaterIntakeViewModel)

        visualizeWaterIntakeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)

        let tabBarList = [trackWaterViewController, visualizeWaterIntakeViewController]

        viewControllers = tabBarList
    }
}
