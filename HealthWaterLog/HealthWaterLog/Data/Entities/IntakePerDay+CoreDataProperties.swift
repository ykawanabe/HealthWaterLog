//
//  IntakePerDay+CoreDataProperties.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension IntakePerDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IntakePerDay> {
        return NSFetchRequest<IntakePerDay>(entityName: "IntakePerDay")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var day: String?

}
