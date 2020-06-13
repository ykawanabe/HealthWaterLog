//
//  TrackWaterViewModel.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TrackWaterViewModel: NSObject {
    private let dataStore: HealthWaterLogDataController
    private let userPreferenceManager: UserPreferenceManager
    
    private let incrementAmount = Int16(8)
    
    let addWaterLabel = "Add \(8) oz Water"
    let updateDailyGoalLabel = "Update Daily Goal"
    
    init(dataStore: HealthWaterLogDataController, userPreferenceManager: UserPreferenceManager) {
        self.dataStore = dataStore
        self.userPreferenceManager = userPreferenceManager
    }
    
    func addWaterIntake() {
        let _ = dataStore.createIntake(amount: incrementAmount)
        dataStore.saveContext()
    }
    
    func addGoal(_ goal: Int) {
        userPreferenceManager.setIntakeGoal(intakeGoal: goal)
    }
}
