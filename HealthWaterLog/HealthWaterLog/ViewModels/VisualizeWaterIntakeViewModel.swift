//
//  VisualizeWaterIntakeViewModel.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VisualizeWaterIntakeViewModel: NSObject, HealthWaterLogDataControllerListener,UserPreferenceManagerListener {
    private let historyDays = 7
    
    private let dataStore: HealthWaterLogDataController
    private let userPreferenceManager: UserPreferenceManager
    
    let currentState = Dynamic<String>("")
    let historyStrings: [String]
    
    init(dataStore: HealthWaterLogDataController, userPreferenceManager: UserPreferenceManager) {
        self.dataStore = dataStore
        self.userPreferenceManager = userPreferenceManager
        self.historyStrings = dataStore.getIntakePerDayForPastDays(historyDays).map{"\($0.day!): \($0.amount) oz" }
        super.init()
        
        dataStore.addListener(self)
        userPreferenceManager.addListener(self)
        
        updateCurrentState()
    }
    
    deinit {
        dataStore.removeListner(self)
        userPreferenceManager.removeListner(self)
    }
    
    private func updateCurrentState() {
        let total = self.dataStore.fetchIntakeAmountForDate(date: Date())
        let goal = self.userPreferenceManager.intakeGoal()
        currentState.value = "\(total) oz of \(goal) oz goal consumed today."
    }
    
    // MARK: HealthWaterLogDataControllerListener
    func managedObjectContextObjectsDidChange(notification: NSNotification) {
        updateCurrentState()
    }
    
    // MARK: UserPreferenceManagerListener
    func userDefaultsDidChange(_ notification: Notification) {
        updateCurrentState()
    }
}
