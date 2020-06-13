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
    private let incrementAmount = Int16(8)
    
    let addWaterLabel = "Add \(8) oz Water"
    let updateDailyGoalLabel = "Update Daily Goal"

    init(dataStore: HealthWaterLogDataController) {
        self.dataStore = dataStore
    }
    
    func addWaterIntake() {
        
    }
    
    func addGoal() {
        
    }
}
