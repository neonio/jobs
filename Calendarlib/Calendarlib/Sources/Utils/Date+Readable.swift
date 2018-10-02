//
//  Date+Readable.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import Foundation
extension Date {
    func secondsAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.second], from: self, to: Date())
        return timeIntervalComponents.second ?? 0
    }
    
    func minutesAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.minute], from: self, to: Date())
        return timeIntervalComponents.minute ?? 0
    }
    
    func hoursAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.hour], from: self, to: Date())
        return timeIntervalComponents.hour ?? 0
    }
    
    func daysAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.day], from: self, to: Date())
        return timeIntervalComponents.day ?? 0
    }
    
    func monthsAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.month], from: self, to: Date())
        return timeIntervalComponents.month ?? 0
    }
    
    func yearsAgo() -> Int {
        let timeIntervalComponents = Calendar.current.dateComponents([.year], from: self, to: Date())
        return timeIntervalComponents.year ?? 0
    }
    
    var isInToday: Bool {
        let currentDate = Date()
        return self.day == currentDate.day && self.month == currentDate.month && self.year == currentDate.year
    }
    
    var startOfThisDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func daysAgoAgainstMidnight() -> Int {
        return Int(startOfThisDay.timeIntervalSinceNow / (-24 * 3600))
    }
    
    func humanReadable(isFuture: Bool = false) -> String {
        let years = yearsAgo()
        if abs(years) > 0 {
            return "\(years)年\(isFuture ? "后" : "前")"
        }
        let months = monthsAgo()
        if abs(months) > 0 {
            return "\(months)个月\(isFuture ? "后" : "前")"
        }
        
        let days = daysAgoAgainstMidnight()
        // handle special case
        if abs(days) > 0 {
            if days == 1 {
                return "\(isFuture ? "明天" : "昨天")"
            } else if days == 2 {
                return "\(isFuture ? "后天" : "前天")"
            } else {
                return "\(days)天\(isFuture ? "前" : "后")"
            }
        }
        let hours = hoursAgo()
        if hours > 0 {
            return "\(days)小时\(isFuture ? "后" : "前")"
        }
        let minutes = minutesAgo()
        if abs(minutes) > 0 {
            return "\(days)分钟\(isFuture ? "后" : "前")"
        }
        
        let seconds = secondsAgo()
        if abs(seconds) > 15 {
            return "\(days)秒\(isFuture ? "后" : "前")"
        } else {
            return "\(isFuture ? "即将" : "刚刚")"
        }
    }
}

extension TimeInterval {
    func humanReadable() -> String {
        var timeCount = Int(self)
        var rst = ""
        let days = timeCount / 86400
        if days > 0 {
            rst += "\(days)天"
            timeCount -= (86400 * days)
        }
        let hours = timeCount / 3600
        if hours > 0 {
            rst += "\(hours)小时"
            timeCount -= (3600 * hours)
        }
        
        let minutes = timeCount / 60
        if minutes > 0 {
            rst += "\(minutes)分钟"
            timeCount -= (60 * minutes)
        }
        
        return rst
    }
}
