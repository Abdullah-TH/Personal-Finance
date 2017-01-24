//
//  NSDateExtension.swift
//  Personal Finance
//
//  Created by Abdullah Althobetey on 3/22/16.
//  Copyright © 2016 Abdullah Althobetey. All rights reserved.
//

import Foundation

extension NSDate
{
    /// return today month and year numbers in the form MM-yyyy (ex. 09-2015 or 12-2016)
    public static func getThisMonthAndYearNumberAsString() -> String
    {
        let date = NSDate()
        let calender = NSCalendar.currentCalendar()
        let components = calender.components([.Month, .Year], fromDate: date)
        let monthInt = components.month
        let yearStr = String(components.year)
        var monthStr = ""
        if monthInt < 10
        {
            monthStr = "0" + String(monthInt)
        }
        else
        {
            monthStr = String(monthInt)
        }
        return "\(monthStr)-\(yearStr)"
    }
    
    /// return today month and year as String in the form "Month, Year" (ex. "March, 2016")
    public static func getThisMonthAndYearAsString() -> String
    {
        let today = NSDate()
        let calender = NSCalendar.currentCalendar()
        let components = calender.components([.Month, .Year], fromDate: today)
        let dateFormatter = NSDateFormatter()
        let monthString = dateFormatter.monthSymbols[components.month - 1] // month symbols start from zero
        let monthAndYearString = monthString + " \(components.year)"
        return monthAndYearString
    }
    
    /// get the date string representation of the number String
    /// parameter number: number is a String that must be in the format "mm-yyyy"
    public static func getMonthAndYearStringFromStringNumber(number: String) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-yyyy"
        let date = dateFormatter.dateFromString(number)!
        let calender = NSCalendar.currentCalendar()
        let components = calender.components([.Month, .Year], fromDate: date)
        let monthString = dateFormatter.monthSymbols[components.month - 1]
        let monthAndYearString = monthString + " \(components.year)"
        return monthAndYearString
    }
    
    /// get a String representation of the supplied NSDate object in the form "yyyy-MM-dd"
    public static func getDateAsString(date date: NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
    
    // return an NSDate object representing the current month and year, and the day is set to the last day in the month
    public static func getDateOfCurrentMonthAndLastDay() -> NSDate
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        var startOfMonth : NSDate?
        var lengthOfMonth : NSTimeInterval = 0
        // set startOfMonth to the first day of the month, and set lengthOfMonth to the length (number of days) of the month
        calendar.rangeOfUnit(.Month, startDate: &startOfMonth, interval: &lengthOfMonth, forDate: date)
        // add lengthOfMonth (contains the number of days of current month) to the startOfMonth to get the last day of the same month
        let endOfMonth = startOfMonth!.dateByAddingTimeInterval(lengthOfMonth - 1)
        return endOfMonth
    }
}



























