//
//  CoreDataManager.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    var healthWaterLogDataController: HealthWaterLogDataController!
    
    func start(completionHandler: @escaping ()->()) {
        healthWaterLogDataController = HealthWaterLogDataController() {
            completionHandler()
        }
    }
}
