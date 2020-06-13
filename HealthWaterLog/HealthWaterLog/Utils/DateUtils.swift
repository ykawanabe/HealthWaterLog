//
//  DateUtils.swift
//  HealthWaterLog
//
//  Created by Yusuke Kawanabe on 6/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.hour = 23
        components.minute = 59
        components.second = 59
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
}

extension Date {
    var string: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return "\(components.year!)-\(components.month!)-\(components.day!)"
    }
}
