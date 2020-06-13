//
//  HealthWaterLogTests.swift
//  HealthWaterLogTests
//
//  Created by Jessie Pease on 5/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest
import CoreData
@testable import HealthWaterLog

class HealthWaterLogTests: XCTestCase {
    lazy var dataController: HealthWaterLogDataController = {
        let semaphore = DispatchSemaphore(value: 0)
        
        let dataController = HealthWaterLogDataController() {
            semaphore.signal()
        }
        
        let _ = semaphore.wait(timeout: .now() + 5.0)
        return dataController
    }()
    
    override func setUpWithError() throws {
        dataController.deleteAll()
    }

    func testIntakeAmount() throws {
        let amount = 8
        let _ = dataController.createIntake(amount: Int16(amount))
        dataController.saveContext()
        
        let total = dataController.fetchIntakeAmountForDate(date: Date())

        XCTAssertEqual(amount, total)
    }
    
    func testEmptyIntakeAmount() throws {
        let amount = 8
        let _ = dataController.createIntake(amount: Int16(amount), date: Date(timeIntervalSince1970: 0))
        dataController.saveContext()
        
        let total = dataController.fetchIntakeAmountForDate(date: Date())

        XCTAssertEqual(total, 0)
    }
    
    func testCreateIntake() throws {
        let amount = Int16(8)
        let _ = dataController.createIntake(amount: amount, date: Date(timeIntervalSince1970: 0))
        dataController.saveContext()
        
        let intakes = dataController.fetchIntakes()

        XCTAssertEqual(intakes.first!.amount, amount)
    }
}
