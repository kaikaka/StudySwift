//
//  DateExtension.swift
//  StudySwift
//
//  Created by Yoon on 2021/3/2.
//

import SwiftDate
import UIKit

public let gregorian = Calendar(identifier: Calendar.Identifier.gregorian) // 公历
public let dateFormatter = DateFormatter()
public let outputDateFormatter = DateFormatter()

extension Date {
    /// 是否大于传入的日期
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        return isAfterDate(dateToCompare, granularity: Calendar.Component.second)
    }

    /// 是否小于传入的日期
    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        return isBeforeDate(dateToCompare, granularity: Calendar.Component.second)
    }

    /// 日期是否相等
    func equalToDate(_ dateToCompare: Date) -> Bool {
        return compare(dateToCompare) == ComparisonResult.orderedSame
    }

    /// 当前日期添加天数
    func addDays(_ daysToAdd: Int) -> Date {
        return self + daysToAdd.days
    }

    /// 当前日期添加小时数
    func addHours(_ hoursToAdd: Int) -> Date {
        return self + hoursToAdd.hours
    }

    /// 获取两个时间的分钟数(四舍五入)
    static func getMinutesFor(_ startAt: String? = nil, from dateString: String!) -> Int {
        var toDate: Date!
        if let startAt = startAt {
            toDate = convertPOSIXStringToDate(from: startAt)
        } else {
            toDate = Date()
        }

        if let dateString = dateString, let dateToCompare = dateString.toDate()?.date {
            let interval = dateToCompare.getInterval(toDate: toDate, component: .second)
            let second = Int(interval)
            return second / 60 + (second % 60 != 0 ? 1 : 0)
        } else {
            print("date format was disformal, using today to replace!")
        }
        return 0
    }

    /// 获取两个时间的秒数(Date类型)
    static func getRunningSeconds(from: Date, to future: Date = Date()) -> Int {
        let interval = from.getInterval(toDate: future, component: .second)
        return Int(interval)
    }

    /// 获取两个时间的秒数(String类型)
    static func getRunningSeconds(dateString: String, to future: Date = Date()) -> Int {
        let dateToCompare = Date.convertPOSIXStringToDate(from: dateString)
        let interval = dateToCompare.getInterval(toDate: future, component: .second)
        return Int(interval)
    }

    /// 按格式转换String -> Date
    static func convertToDate(_ datestr: String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var strDate = dateFormatter.date(from: datestr)

        if strDate == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            strDate = dateFormatter.date(from: datestr)
        }
        if strDate == nil {
            print("date format was disformal, using today to replace!")
        }
        return strDate ?? Date()
    }

    /// 三种格式转换 Date -> String
    static func convertToDateString(_ date: Date, includeYear: Bool = true, includeOnlyDay: Bool = false) -> String {
        if includeOnlyDay {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        } else if includeYear {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        } else {
            dateFormatter.dateFormat = "MM-dd HH:mm:ss"
        }
        return dateFormatter.string(from: date)
    }

    static func convertToSimplestDateString(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }

    static func convertToSimplestDateString(_ datestr: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.date(from: datestr.components(separatedBy: " ").first!)

        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: strDate!)
    }

    static func convertToSimpleDateString(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }

    static func convertPOSIXStringToDate(from datestr: String) -> Date {
        let date = datestr.toDate()
        if let date = date {
            return date.date
        } else {
            return Date()
        }
    }

    static func convertPOSIXStringToDateString(_ datestr: String, includeZone: Bool = false, includeYear: Bool = true, includeOnlyDay: Bool = false) -> String {
        let date = convertPOSIXStringToDate(from: datestr)
        return convertToDateString(date, includeYear: includeYear, includeOnlyDay: includeOnlyDay)
    }

    static func convertPOSIXStringToSimpleDateString(_ datestr: String, includeZone: Bool = false) -> String {
        let date = convertPOSIXStringToDate(from: datestr)
        return convertToSimpleDateString(date)
    }

    /// 字符串时间比较
    static func components(_ date: String) -> DateComponents {
        let tDate = convertToDate(date)
        let result = gregorian.dateComponents([.day, .month, .year], from: tDate)
        return result
    }

    /// 时间比较
    static func dateComponents(_ date: Date) -> DateComponents {
        let result = gregorian.dateComponents([.day, .month, .year], from: date)
        return result
    }

    /// 获取某年开始时间
    static func stringForBeginOfYear(at year: Int?) -> String? {
        guard let year = year else { return nil }
        return "\(year)-1-1 00:00:00"
    }

    /// 获取某年结束时间
    static func stringForEndOfYear(at year: Int?) -> String? {
        guard let year = year else { return nil }
        return "\(year + 1)-1-1 00:00:00"
    }

    /// 时间是不是今天
    static func isToday(_ interval: TimeInterval) -> Bool {
        let date = Date(timeIntervalSince1970: interval)
        return date.isToday
    }

    /// 某个时间 加几天
    static func someDayAfter(_ from: Date = Date(), day: Int) -> Date {
        return from + day.days
    }

    /// 年
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// 月
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// 日期
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// 时
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// 分
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    /// 秒
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    /// 纳秒
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }

    /// 季度
    var quarter: Int {
        return Calendar.current.component(.quarter, from: self)
    }

    /// 星期 1～7 默认第一天为星期天，可以在设置中进行设置修改
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    /// 当前月份的工作周第几周
    var weekdayOrdinal: Int {
        return Calendar.current.component(.weekdayOrdinal, from: self)
    }

    /// 当前月的第几周 1~5
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }

    /// 当年的第几周 1~53
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// 基于ISO week date
    /// https://en.wikipedia.org/wiki/ISO_week_date
    var yearForWeakOfYear: Int {
        return Calendar.current.component(.yearForWeekOfYear, from: self)
    }

    /// 是否闰月
    var isLeapMonth: Bool {
        return Calendar.current.dateComponents([.quarter], from: self).isLeapMonth ?? false
    }

    /// 是否是闰年
    var isLeapYear: Bool {
        return (year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0))
    }
}

public extension Date {
    /// 返回增加指定年数后的日期
    ///
    /// - Parameter years: 年数
    /// - Returns: 如果年数增加后错误则返回当前日期
    func adding(years: Int) -> Date {
        var components = DateComponents()
        components.year = years
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定月数后的日期
    ///
    /// - Parameter months: 月数
    /// - Returns: 如果月数增加后错误则返回当前日期
    func adding(months: Int) -> Date {
        var components = DateComponents()
        components.month = months
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定周数后的日期
    ///
    /// - Parameter weaks: 周数
    /// - Returns: 如果周数增加后错误则返回当前日期
    func adding(weaks: Int) -> Date {
        var components = DateComponents()
        components.weekOfYear = weaks
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定天数后的日期
    ///
    /// - Parameter days: 天数
    /// - Returns: 如果天数增加后错误则返回当前日期
    func adding(days: Int) -> Date {
        var components = DateComponents()
        components.day = days
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定小时数后的日期
    ///
    /// - Parameter hours: 小时数
    /// - Returns: 如果小时数增加后错误则返回当前日期
    func adding(hours: Int) -> Date {
        var components = DateComponents()
        components.hour = hours
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定分钟数后的日期
    ///
    /// - Parameter minutes: 分钟数
    /// - Returns: 如果分钟数增加后错误则返回当前日期
    func adding(minutes: Int) -> Date {
        var components = DateComponents()
        components.minute = minutes
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回增加指定秒数后的日期
    ///
    /// - Parameter seconds: 秒数
    /// - Returns: 如果秒数增加后错误则返回当前日期
    func adding(seconds: Int) -> Date {
        var components = DateComponents()
        components.second = seconds
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }

    /// 返回指定格式的字符串
    ///
    ///     date.string(format: "yyyy-MM-dd HH:mm:ss")
    ///
    /// - Parameters:
    ///   - format: 日期格式
    ///   - timeZone: 时区 默认当前时区
    ///   - locale: 地区 默认当前地区
    /// - Returns: 日期字符串
    func string(format: String, timeZone: TimeZone? = nil, locale: Locale? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let timeZone = timeZone { formatter.timeZone = timeZone } else { formatter.timeZone = .current }
        if let locale = locale { formatter.locale = locale } else { formatter.locale = .current }
        return formatter.string(from: self)
    }
}
