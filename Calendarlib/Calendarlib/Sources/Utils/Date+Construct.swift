//
//  Date+Construct.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import Foundation
struct WeekSpan {
    var startTime: Date?
    var endTime: Date?
}

extension Date {
    func monthStartDate() -> Date? {
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        comp.day = 1
        return comp.date
    }
    
    func monthLastDate() -> Date? {
        var comp = calendar.dateComponents([.year, .month, .day], from: self)
        guard let monthNum = comp.month else {
            return nil
        }
        comp.month = 1 + monthNum
        comp.day = 0
        return comp.date
    }
    
    func weekStartDate() -> Date? {
        return weekSpan()?.startTime
    }
    
    func weekLastDate() -> Date? {
        return weekSpan()?.endTime?.startOfThisDay
    }
    
    func weekSpan() -> WeekSpan? {
        var startOfWeek: Date = Date()
        var interval: TimeInterval = 0
        let result = calendar.dateInterval(of: .weekOfYear, start: &startOfWeek, interval: &interval, for: self)
        if !result {
            return nil
        }
        
        let endDate = startOfWeek + Int(interval - 1).seconds
        return WeekSpan(startTime: startOfWeek, endTime: endDate)
    }
    
    func beginning(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self))
            
        case .minute:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self))
            
        case .hour:
            return calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: self))
            
        case .day:
            return self.calendar.startOfDay(for: self)
            
        case .weekOfYear, .weekOfMonth:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))
            
        case .month:
            return calendar.date(from: calendar.dateComponents([.year, .month], from: self))
            
        case .year:
            return calendar.date(from: calendar.dateComponents([.year], from: self))
            
        default:
            return nil
        }
    }
    
    func end(of component: Calendar.Component) -> Date? {
        switch component {
        case .second:
            let date = self + 1.second
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)) else {
                return nil
            }
            return after - 1.second
            
        case .minute:
            let date = self + 1.minute
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)) else {
                return nil
            }
            return after - 1.second
            
        case .hour:
            let date = self + 1.hour
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month, .day, .hour], from: date)) else {
                return nil
            }
            return after - 1.second
            
        case .day:
            let date = self + 1.day
            let startOfDay = date.startOfThisDay
            return startOfDay - 1.second
        case .weekOfYear, .weekOfMonth:
            let date = self
            guard let beginningOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else {
                return nil
            }
            let endOfWeek = beginningOfWeek + 7.days
            return endOfWeek - 1.second
        case .month:
            let date = self + 1.month
            guard let after = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
                return nil
            }
            return after - 1.second
            
        case .year:
            let date = self + 1.year
            guard let after = calendar.date(from: calendar.dateComponents([.year], from: date)) else {
                return nil
            }
            return after - 1.second
            
        default:
            return nil
        }
    }
    
    static func + (left: Date, right: DateComponents) -> Date {
        if let result = Calendar.current.date(byAdding: right, to: left) {
            return result
        }
        print("[ERROR]:\(left) add \(right)")
        return left
    }
    
    static func - (left: Date, right: DateComponents) -> Date? {
        if let result = Calendar.current.date(byAdding: -right, to: left) {
            return result
        }
        print("[ERROR]:\(left) substract \(right)")
        return left
    }
    
    init(
        calendar: Calendar? = Calendar.current,
        timeZone: TimeZone? = TimeZone.current,
        era: Int? = Date().era,
        year: Int? = Date().year,
        month: Int? = Date().month,
        day: Int? = Date().day,
        hour: Int? = Date().hour,
        minute: Int? = Date().minute,
        second: Int? = Date().second,
        nanosecond: Int? = Date().nanosecond) {
        var components = DateComponents()
        components.calendar = calendar
        components.timeZone = timeZone
        components.era = era
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        components.nanosecond = nanosecond
        
        self = calendar?.date(from: components) ?? Date()
    }
    
    private var dateComponents: DateComponents {
        return calendar.dateComponents([.era, .year, .month, .day, .hour, .minute, .second, .nanosecond, .weekday], from: self)
    }
    
    var calendar: Calendar {
        return Calendar.current
    }
    
    var timeZone: TimeZone {
        return TimeZone.current
    }
    
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: newValue, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    var quarter: Int {
        return calendar.component(.quarter, from: self)
    }
    
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: newValue, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    var weekOfYear: Int {
        return calendar.component(.weekOfYear, from: self)
    }
    
    var weekOfMonth: Int {
        return calendar.component(.weekOfMonth, from: self)
    }
    
    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }
    
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: newValue, hour: hour, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: newValue, minute: minute, second: second, nanosecond: nanosecond)
        }
    }
    
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: newValue, second: second, nanosecond: nanosecond)
        }
    }
    
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            self = Date(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: newValue, nanosecond: nanosecond)
        }
    }
    
    var nanosecond: Int {
        return calendar.component(.nanosecond, from: self)
    }
    
    var era: Int {
        return calendar.component(.era, from: self)
    }
}

extension DateComponents {
    static prefix func - (rhs: DateComponents) -> DateComponents {
        var dateComponents = DateComponents()
        
        if let year = rhs.year {
            dateComponents.year = -year
        }
        
        if let month = rhs.month {
            dateComponents.month = -month
        }
        
        if let day = rhs.day {
            dateComponents.day = -day
        }
        
        if let hour = rhs.hour {
            dateComponents.hour = -hour
        }
        
        if let minute = rhs.minute {
            dateComponents.minute = -minute
        }
        
        if let second = rhs.second {
            dateComponents.second = -second
        }
        
        if let nanosecond = rhs.nanosecond {
            dateComponents.nanosecond = -nanosecond
        }
        
        return dateComponents
    }
    
    static func + (left: DateComponents, right: DateComponents) -> DateComponents {
        var dateComponents = left
        
        if let year = right.year {
            dateComponents.year = (dateComponents.year ?? 0) + year
        }
        
        if let month = right.month {
            dateComponents.month = (dateComponents.month ?? 0) + month
        }
        
        if let day = right.day {
            dateComponents.day = (dateComponents.day ?? 0) + day
        }
        
        if let hour = right.hour {
            dateComponents.hour = (dateComponents.hour ?? 0) + hour
        }
        
        if let minute = right.minute {
            dateComponents.minute = (dateComponents.minute ?? 0) + minute
        }
        
        if let second = right.second {
            dateComponents.second = (dateComponents.second ?? 0) + second
        }
        
        if let nanosecond = right.nanosecond {
            dateComponents.nanosecond = (dateComponents.nanosecond ?? 0) + nanosecond
        }
        
        return dateComponents
    }
    
    static func - (left: DateComponents, right: DateComponents) -> DateComponents {
        return left + (-right)
    }
}

extension Int {
    var year: DateComponents {
        return DateComponents(year: self)
    }
    
    var years: DateComponents {
        return year
    }
    
    var month: DateComponents {
        return DateComponents(month: self)
    }
    
    var months: DateComponents {
        return month
    }
    
    var week: DateComponents {
        return DateComponents(day: 7 * self)
    }
    
    var weeks: DateComponents {
        return week
    }
    
    var day: DateComponents {
        return DateComponents(day: self)
    }
    
    var days: DateComponents {
        return day
    }
    
    var hour: DateComponents {
        return DateComponents(hour: self)
    }
    
    var hours: DateComponents {
        return hour
    }
    
    var minute: DateComponents {
        return DateComponents(minute: self)
    }
    
    var minutes: DateComponents {
        return minute
    }
    
    var second: DateComponents {
        return DateComponents(second: self)
    }
    
    var seconds: DateComponents {
        return second
    }
    
    var nanosecond: DateComponents {
        return DateComponents(nanosecond: self)
    }
    
    var nanoseconds: DateComponents {
        return nanosecond
    }
}
