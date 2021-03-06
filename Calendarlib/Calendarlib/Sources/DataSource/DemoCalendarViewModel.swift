//
//  DemoCalendarViewModel.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import EventKit
import UIKit
enum CalendarMode {
    case month
    case week
}

enum CalendarScrollDirection {
    case vertical
    case horizontal
}

enum CalendarMonthPosition {
    case current
    case previousMonth
    case nextMonth
    case placeholder
}

class DemoCalendarViewModel: NSObject {
    var headDateFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MM")
    var headShortDateFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MMMM yyyy")
    var tableDayFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "MMMM dd")
    var tableWeekFormat: DateFormatter = DateFormatFactory.shared.dateFormatter(format: "EEEE")
    
    var pickedDate: Date = Date()
    
    var pickedDateDesc: String {
        return headShortDateFormat.string(from: pickedDate)
    }
    
    func startDate(at section: Int) -> Date {
        return Date()
    }
    
    func sectionTitle(section: Int) -> String {
        let refDate = dateIn(section: section)
        let dateStr = tableDayFormat.string(from: refDate).uppercased()
        let weekDate = tableWeekFormat.string(from: refDate).uppercased()
        return weekDate + ", " + dateStr
    }
    
    convenience init(calculator: CalendarCalculator) {
        self.init()
        self.calculator = calculator
    }
    
    override init() {
        super.init()
    }
    
    lazy var calculator: CalendarCalculator = {
        CalendarCalculator()
    }()
}

extension DemoCalendarViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CalendarEventCell.self), for: indexPath) as! CalendarEventCell
        cell.separatorInset = .zero
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        event.calendar = EKCalendar(for: .event, eventStore: store)
        event.title = (indexPath.row % 2 == 0 ? "Outlook Mobile All Hands" : "Outlook Mobile All Hands,Outlook Mobile All HandsOutlook Mobile All Hands")
        event.location = "Conf Room 1355 Market"
        var attendees = [EKParticipant]()
        for i in 0 ..< 5 {
            if let attendee = createParticipant(email: "test\(i)@email.com"), indexPath.row % 3 == 0 {
                attendees.append(attendee)
            }
        }
        event.setValue(attendees, forKey: "attendees")
        event.startDate = Date(timeIntervalSinceNow: -3600)
        event.endDate = Date(timeIntervalSinceNow: 3600)
        cell.update(model: event)
        return cell
    }
    
    private func createParticipant(email: String) -> EKParticipant? {
        let clazz: AnyClass? = NSClassFromString("EKAttendee")
        if let type = clazz as? NSObject.Type {
            let attendee = type.init()
            attendee.setValue("V", forKey: "firstName")
            attendee.setValue("f", forKey: "lastName")
            attendee.setValue(email, forKey: "emailAddress")
            return attendee as? EKParticipant
        }
        return nil
    }
    
    func dateIn(section: Int) -> Date {
        return calculator.minDate + (section + 1).days
    }
    
    func tableViewSectionIn(date: Date) -> Int {
        let beginDate = date.startOfThisDay
        return calculator.calendar.dateComponents([.day], from: calculator.minDate, to: beginDate).day ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return calculator.calendar.dateComponents([.day], from: calculator.minDate, to: calculator.maxDate).day ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
}
