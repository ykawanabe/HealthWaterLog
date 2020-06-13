//
//  UserPreferenceManager.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UserPreferenceManager: NSObject {
    private let goalKey = "goalKey"
    
    func setIntakeGoal(intakeGoal: Int) {
        UserDefaults.standard.set(intakeGoal, forKey: goalKey)
    }
    
    func intakeGoal() -> Int {
        UserDefaults.standard.integer(forKey: goalKey)
    }
}
