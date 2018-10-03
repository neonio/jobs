//
//  DemoCalendarViewModel.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import EventKit
import UIKit
class DemoCalendarViewModel {
    var headDateFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MM")
    var headShortDateFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MMMM yyyy")
    var tableDayFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MM/dd")
    var tableWeekFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "EEE")
    
    var pickedDate: Date = Date()
    
    var pickedDateDesc: String {
        return headShortDateFormat.string(from: pickedDate)
    }
    
    func startDate(at section: Int) -> Date {
        return Date()
    }
    
    func sectionTitle(section: Int) -> String {
        let refDate = startDate(at: section)
        let dateStr = tableDayFormat.string(from: refDate)
        let weekDate = tableWeekFormat.string(from: refDate)
        return dateStr + weekDate
    }
    
    lazy var eventStore: EKEventStore = {
        let store = EKEventStore()
        return store
    }()
    
    func requestCalendarPermissionIfNeeded() {
        if EKEventStore.authorizationStatus(for: .event) == .notDetermined {
            eventStore.requestAccess(to: .event) { [weak self] isGranted, error in
                guard let self = self else { return }
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if isGranted {
                        self.update()
                    } else {
                        print("No calendar permission")
                    }
                }
            }
        }
    }
    
    func update() {}
    
    init() {}
}
