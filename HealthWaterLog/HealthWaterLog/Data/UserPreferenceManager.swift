//
//  UserPreferenceManager.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@objc
protocol UserPreferenceManagerListener {
    func userDefaultsDidChange(_ notification: Notification);
}

class UserPreferenceManager: NSObject {
    static var shared = UserPreferenceManager()
    
    private let goalKey = "goalKey"
    private let userDefaults = UserDefaults.standard
    
    func setIntakeGoal(intakeGoal: Int) {
        userDefaults.set(intakeGoal, forKey: goalKey)
    }
    
    func intakeGoal() -> Int {
        userDefaults.integer(forKey: goalKey)
    }
    
    func addListener<T: UserPreferenceManagerListener>(_ listener: T) {
        NotificationCenter.default.addObserver(listener, selector: #selector(listener.userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    func removeListner<T: UserPreferenceManagerListener>(_ listener: T) {
        NotificationCenter.default.removeObserver(listener, name: UserDefaults.didChangeNotification, object: nil)
    }
}
