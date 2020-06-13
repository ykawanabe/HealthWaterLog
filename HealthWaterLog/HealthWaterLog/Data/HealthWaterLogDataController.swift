//
//  HealthWaterLogController.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

@objc 
protocol HealthWaterLogDataControllerListener {
    func managedObjectContextObjectsDidChange(notification: NSNotification);
}

class HealthWaterLogDataController: NSObject {
    var container: NSPersistentContainer!
    
    init(container: NSPersistentContainer, completionHandler: @escaping () -> ()) {
        self.container = container
        super.init()
        
        container.loadPersistentStores { [weak self] (description, error) in
            if let error = error {
                fatalError("Core Data loading error \(error)")
            }
            
            self?.connectIntakePerDay()
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    convenience init(completionHandler: @escaping () -> ()) {
        let container = NSPersistentContainer(name: "HealthWaterLog")
        self.init(container: container, completionHandler: completionHandler)
    }
    
    func createIntake(amount: Int16, date: Date = Date()) -> Intake {
        let context = container.viewContext
        let intake = NSEntityDescription.insertNewObject(forEntityName: "Intake", into: context) as! Intake
        intake.amount = amount
        intake.timestamp = date
        return intake
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func fetchIntakes() -> [Intake] {
        let context = container.viewContext
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Intake")
        
        do {
            return try context.fetch(fr) as! [Intake]
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    func fetchIntakeAmountForDate(date: Date) -> Int {
        let context = container.viewContext
        
        let ced = NSExpressionDescription()
        ced.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "amount")])
        ced.name = "total"
        ced.expressionResultType = .integer64AttributeType
        
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Intake")
        fr.predicate = NSPredicate(format: "timestamp > %@ AND timestamp <= %@", argumentArray: [date.startOfDay, date.endOfDay])
        fr.propertiesToFetch = [ced]
        fr.resultType = .dictionaryResultType
       
        do {
            let results =  try context.fetch(fr)
            let resultMap = results.first as? [String:Int]
            return resultMap?["total"] ?? 0
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    func deleteAll() {
        deleteAllEntity(entityName: "Intake")
        deleteAllEntity(entityName: "IntakePerDay")
    }
    
    func deleteAllEntity(entityName: String) {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
        
        let context = container.viewContext
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            fatalError("Failed to delete all: \(error)")
        }
    }
    
    func addListener<T: HealthWaterLogDataControllerListener>(_ listener: T) {
        let context = container.viewContext
        NotificationCenter.default.addObserver(listener, selector: #selector(listener.managedObjectContextObjectsDidChange), name: .NSManagedObjectContextObjectsDidChange, object: context)
    }
    
    func removeListner<T: HealthWaterLogDataControllerListener>(_ listener: T) {
        let context = container.viewContext
        NotificationCenter.default.removeObserver(listener, name: .NSManagedObjectContextObjectsDidChange, object: context)
    }
}

extension HealthWaterLogDataController {
    @objc func contextWillSave(_ notification: Notification) {
        guard let context = notification.object as? NSManagedObjectContext else { return }
        
        context.performAndWait {
            for case let intake as Intake in context.insertedObjects {
                let intakePerDay = getIntakePerDay(forDay: intake.timestamp!)
                intakePerDay.amount += intake.amount
            }
        }
    }
    
    fileprivate func connectIntakePerDay() {
        let context = container.viewContext
        NotificationCenter.default.addObserver(self, selector: #selector(contextWillSave), name: .NSManagedObjectContextWillSave, object: context)
    }
    
    
    func getIntakePerDay(forDay: Date) -> IntakePerDay {
        let context = container.viewContext
        let dateString = forDay.string
        
        let fetchRequest = NSFetchRequest<IntakePerDay>(entityName: "IntakePerDay")
        fetchRequest.predicate = NSPredicate(format: "day == %@", dateString)
        
        do {
            let results =  try context.fetch(fetchRequest)
            let resultMap = results.first
            
            if let resultMap = resultMap {
                return resultMap
            } else {
                let intakePerDay = NSEntityDescription.insertNewObject(forEntityName: "IntakePerDay", into: context) as! IntakePerDay

                intakePerDay.amount = Int16(0)
                intakePerDay.day = dateString
                return intakePerDay
            }
        } catch {
            fatalError("Failed to fetch: \(error)")
        }
    }
    
    func getIntakePerDayForPastDays(_ days: Int) -> [IntakePerDay] {
        if days < 1 {
            return []
        }
        
        let range = 1...days
        let dates = range.map {Calendar.current.date(byAdding: DateComponents(day: -($0)), to: Date())!}
        let intakePerDays = dates.map { getIntakePerDay(forDay: $0) }
        return intakePerDays
    }
}
