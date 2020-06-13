//
//  Intake+CoreDataProperties.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//
//

import Foundation
import CoreData


extension Intake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Intake> {
        return NSFetchRequest<Intake>(entityName: "Intake")
    }

    @NSManaged public var amount: Int16
    @NSManaged public var timestamp: Date?

}
