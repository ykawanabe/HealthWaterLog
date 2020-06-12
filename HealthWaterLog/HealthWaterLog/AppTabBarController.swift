//
//  AppTabBarController.swift
//  HealthWaterLog
//
//  Created by Jessie Pease on 5/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AppTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trackWaterViewController = TrackWaterViewController()
                
        trackWaterViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let visualizeWaterIntakeViewController = VisualizeWaterIntakeViewController()

        visualizeWaterIntakeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)

        let tabBarList = [trackWaterViewController, visualizeWaterIntakeViewController]

        viewControllers = tabBarList
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
