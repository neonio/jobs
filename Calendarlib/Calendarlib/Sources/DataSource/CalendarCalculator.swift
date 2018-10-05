//
//  CalendarCalculator.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/3.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class CalendarCalculator {
    // MARK: - methods
    
    // MARK: - Reload
    
    private func clearMem() {
        memCache = CalendarDateCache()
    }
    
    func reloadSection() {
        let minMonthStartDate = minDate.monthStartDate() ?? minDate
        let minWeekStartDate = minDate.weekStartDate() ?? minDate
        monthCount = calendar.dateComponents([.month], from: minMonthStartDate, to: maxDate).month ?? 0
        weekCount = calendar.dateComponents([.weekOfYear], from: minWeekStartDate, to: maxDate).weekOfYear ?? 0
        clearMem()
    }
    
    @objc func actionWhenMemoryWarning() {
        clearMem()
    }
    
    func weekStartDate(section: Int) -> Date {
        if let date = memCache.weeks[section] {
            return date
        } else {
            let calculateVal = minDate + section.weeks
            memCache.weeks[section] = calculateVal
            return calculateVal
        }
    }
    
    func numberOfSection() -> Int {
        switch mode {
        case .month:
            return monthCount
        case .week:
            return weekCount
        }
    }
    
    func numberOfDaysInMonth(date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    func numberOfRowsInMonth(date: Date) -> Int {
        if let rowCount = memCache.rows[date] {
            return rowCount
        } else {
            guard let firstDateOfMonth: Date = date.monthStartDate() else {
                return 0
            }
            var row: Int = 0
            let monthDayCount = numberOfDaysInMonth(date: firstDateOfMonth)
            let lastMonthDaysCount = numberOfLastMonthDaysInThisSection(monthStartDate: date)
            row += ((monthDayCount + lastMonthDaysCount) / 7)
            if lastMonthDaysCount % 7 > 0 {
                row += 1
            }
            memCache.rows[date] = row
            return row
        }
    }
    
    func numberOfRows(section: Int) -> Int {
        switch mode {
        case .week:
            return 1
        case .month:
            let monthDate = monthStartDate(section: section)
            let rowCount = numberOfRowsInMonth(date: monthDate)
            return rowCount
        }
    }
    
    func numberOfLastMonthDaysInThisSection(monthStartDate: Date) -> Int {
        let currentWeekday = monthStartDate.weekday
        var preCount = (currentWeekday - calendar.firstWeekday + 7) % 7
        if preCount == 0 {
            preCount = 7
        }
        return preCount
    }
    
    func monthPageLeadingDate(section: Int) -> Date {
        if let date = memCache.monthLeadings[section] {
            // query section from cache
            return date
        } else {
            // calculate section
            
            let calculateVal = minDate + section.months
            let preCount = numberOfLastMonthDaysInThisSection(monthStartDate: calculateVal)
            memCache.months[section] = calculateVal
            let resultLeadingDate: Date = calculateVal - preCount.days
            memCache.monthLeadings[section] = resultLeadingDate
            return resultLeadingDate
        }
    }
    
    func monthStartDate(section: Int) -> Date {
        if let date = memCache.months[section] {
            // query section from cache
            return date
        } else {
            // calculate section
            let calculateVal = minDate + section.months
            let currentWeekday = calculateVal.weekday
            var preCount = (currentWeekday - calendar.firstWeekday + 7) % 7
            if preCount == 0 {
                preCount = 7
            }
            memCache.months[section] = calculateVal
            let resultLeadingDate: Date = calculateVal + preCount.days
            memCache.monthLeadings[section] = resultLeadingDate
            return calculateVal
        }
    }
    
    func getMonthPosition(indexPath: IndexPath) -> CalendarMonthPosition {
        if mode == .week { return .current }
        let currentDate = getDate(indexPath: indexPath, mode: mode)
        let startDate = monthStartDate(section: indexPath.section)
        let result = calendar.compare(currentDate, to: startDate, toGranularity: .month)
        switch result {
        case .orderedAscending:
            return .previousMonth
        case .orderedSame:
            return .current
        case .orderedDescending:
            return .nextMonth
        }
    }
    
    func getDate(indexPath: IndexPath, mode: CalendarMode) -> Date {
        switch mode {
        case .month:
            let startOfMonth = monthStartDate(section: indexPath.section)
            return startOfMonth + indexPath.row.day
        case .week:
            let startOfWeek = weekStartDate(section: indexPath.section)
            return startOfWeek + indexPath.row.day
        }
    }
    
    func getIndexPath(date: Date, mode: CalendarMode, inPosition: CalendarMonthPosition) -> IndexPath? {
        var resultIndexPath: IndexPath?
        switch mode {
        case .month:
            // 1. get month index from minDate to currrent time
            guard let section = calendar.dateComponents([.month], from: minDate, to: date).month else {
                return nil
            }
            var resultSection = section
            switch inPosition {
            case .previousMonth:
                resultSection += 1
            case .nextMonth:
                resultSection -= 1
            case .current:
                break
            }
            // 2. get start Date in this section
            let leadingDate = monthStartDate(section: section)
            // 3. calculate offset
            guard let row = calendar.dateComponents([.day], from: leadingDate, to: date).day else {
                return nil
            }
            // 4. return result
            resultIndexPath = IndexPath(row: row, section: resultSection)
        case .week:
            guard let section = calendar.dateComponents([.weekOfYear], from: minDate.weekStartDate()!, to: date.weekStartDate()!).weekOfYear else {
                return nil
            }
            let row = (date.weekday - calendar.firstWeekday + 7) % 7
            resultIndexPath = IndexPath(row: row, section: section)
        }
        
        return resultIndexPath
    }
    
    func fitDateByScope(originDate: Date) -> Date {
        if originDate < minDate {
            return minDate
        }
        if originDate > maxDate {
            return maxDate
        }
        return originDate
    }
    
    // MARK: - loading
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionWhenMemoryWarning), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - property
    
    var isScrollModeEnabled: Bool = true
    var mode: CalendarMode = .month
    var monthCount: Int = 0
    var weekCount: Int = 0
    var memCache: CalendarDateCache = CalendarDateCache()
    var calendar: Calendar = Calendar.current
    var minDate: Date = Date(timeIntervalSince1970: 0)
    var maxDate: Date = Date(timeIntervalSince1970: 0) + 100.years
}

class CalendarDateCache {
    // store month start date time
    var months: [Int: Date] = [:]
    // store leading time for section
    var monthLeadings: [Int: Date] = [:]
    var weeks: [Int: Date] = [:]
    // store item number
    var rows: [Date: Int] = [:]
}
