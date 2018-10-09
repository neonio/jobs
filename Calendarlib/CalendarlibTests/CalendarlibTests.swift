//
//  CalendarlibTests.swift
//  CalendarlibTests
//
//  Created by amoyio on 2018/10/9.
//  Copyright © 2018 amoyio. All rights reserved.
//

@testable import Calendarlib
import XCTest

class CalendarlibTests: XCTestCase {
    var presetDate: Date!
    var calculator: CalendarCalculator = CalendarCalculator()
    override func setUp() {
        let string = "2018 10 1 00 00 00"
        let format = DateFormatter()
        format.calendar = calculator.calendar
        format.timeZone = TimeZone(secondsFromGMT: 0)
        format.dateFormat = "yyyy MM dd hh mm ss"
        presetDate = format.date(from: string)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCalculatorNumberOfDaysInMonth() {
        let result = calculator.numberOfDaysInMonth(date: presetDate)
        XCTAssert(result == 31, "invalid month number")
    }

    func testNumberOfLastMonthDaysInThisSection() {
        let result = calculator.numberOfLastMonthDaysInThisSection(monthStartDate: presetDate)
        XCTAssert(result == 1, "invalid month")
    }

    func testMonthStartOfDate() {
        let result = calculator.monthStartDate(section: 0)
        XCTAssert(result == calculator.minDate, "testMonthStartDate failed \(result)")

        let result2 = calculator.monthStartDate(section: 20)
        XCTAssert(result2 == calculator.minDate + 20.month, "testMonthStartDate failed \(result)")
    }

    func testGetIndexPath() {
        if let indexPath = calculator.getIndexPath(date: presetDate, mode: .month, inPosition: .current) {
            let result = calculator.getDate(indexPath: indexPath, mode: .month)
            XCTAssert(result == presetDate, "testMonthStartDate failed \(result) and \(String(describing: presetDate))")
        } else {
            _ = XCTAssert(false, "getIndexPath Failed")
        }
    }
    
    func testFitDateByScope() {
        var testDate = calculator.minDate - 1.day
        testDate = calculator.fitDateByScope(originDate: testDate)
        XCTAssert(testDate == calculator.minDate, "Test Fail")
        
        var testDateMax = calculator.maxDate + 1.day
        testDateMax = calculator.fitDateByScope(originDate: testDateMax)
        XCTAssert(testDateMax == calculator.maxDate, "Test Fail")
    }
    
    func testMonthPageLeadingDate() {
        let date = calculator.monthPageLeadingDate(section: 0)
        let targetDate = calculator.getDate(indexPath: IndexPath(row: 0, section: 0), mode: .month)
        XCTAssert(targetDate == date, "Test Fail")
    }
}
