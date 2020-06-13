//
//  HealthWaterLogController.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import CoreData

class HealthWaterLogDataController: NSObject {
    var container: NSPersistentContainer!
    
    init(container: NSPersistentContainer, completionHandler: @escaping () -> ()) {
        self.container = container
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data loading error \(error)")
            }
            
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
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Intake")

        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
        
        let context = container.viewContext
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            fatalError("Failed to delete all: \(error)")
        }
    }
}
