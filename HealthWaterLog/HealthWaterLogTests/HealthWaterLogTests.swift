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
    
    func testIntakePerDay() throws {
        let amount = 8
        let loop = 3
        for _ in 0..<3 {
            let _ = dataController.createIntake(amount: Int16(amount), date: Date())
        }
        
        dataController.saveContext()
        
        let perDay = dataController.getIntakePerDay(forDay: Date())

        XCTAssertEqual(perDay.amount, Int16(amount * loop))
    }
    
    func testEmptyIntakePerDay() throws {
        let amount = 8
        let _ = dataController.createIntake(amount: Int16(amount), date: Date(timeIntervalSince1970: 0))
        
        let yesterday = Calendar.current.date(byAdding: DateComponents(day: -1), to: Date())!
        let _ = dataController.createIntake(amount: Int16(amount), date: yesterday)
        dataController.saveContext()
        
        let perDay = dataController.getIntakePerDay(forDay: Date())

        XCTAssertEqual(perDay.amount, 0)
    }
    
    func testCreateIntake() throws {
        let amount = Int16(8)
        let _ = dataController.createIntake(amount: amount, date: Date(timeIntervalSince1970: 0))
        dataController.saveContext()
        
        let intakes = dataController.fetchIntakes()

        XCTAssertEqual(intakes.first!.amount, amount)
    }
}
