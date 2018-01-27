//
//  BaseHelper.swift
//  InfoNetPm
//
//  Created by jyv on 12/23/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation

func jdFromNow() -> Double {
    let date = Date.init(timeIntervalSinceNow: 0)
    let JD_JAN_1_1970_0000GMT = 2440587.5
    return JD_JAN_1_1970_0000GMT + date.timeIntervalSince1970 / 86400
}

func jdFromDate(date : NSDate) -> Double {
    let JD_JAN_1_1970_0000GMT = 2440587.5
    return JD_JAN_1_1970_0000GMT + date.timeIntervalSince1970 / 86400
}

func dateFromJd(jd : Double) -> NSDate {
    let JD_JAN_1_1970_0000GMT = 2440587.5
    return  NSDate(timeIntervalSince1970: (jd - JD_JAN_1_1970_0000GMT) * 86400)
}

func dateMin() -> Date {
    var components = DateComponents()
    components.year = -100
    return Calendar.current.date(byAdding: components, to: Date())!
}

extension Date {
    public func str() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
        return formatter.string(from: self)
    }
}

func dateToString(_ dateStr: Any?)-> Date
{
    let sdate = dateStr as! String
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssX"
    dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
    let dataDate = dateFormatter.date(from: sdate )!
    return dataDate
}



