//
//  DemoCalendarViewModel.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class DemoCalendarViewModel {
    var headDateFormat:DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MM")
    var headShortDateFormat:DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MMMM yyyy")
    var tableDayFormat:DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MM/dd")
    var tableWeekFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "EEE")
    
    var pickedDate: Date = Date()
    
    var pickedDateDesc: String {
        return headShortDateFormat.string(from: pickedDate)
    }
    
    func startDate(at section:Int) -> Date {
        return Date()
    }
    
    func sectionTitle(section:Int) -> String {
        let refDate = startDate(at: section)
        let dateStr = tableDayFormat.string(from: refDate)
        let weekDate = tableWeekFormat.string(from: refDate)
        return dateStr + weekDate
    }
    
    init() {
        
    }
}
