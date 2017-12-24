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
