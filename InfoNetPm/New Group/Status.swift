//
//  DbStat.swift
//  InfoNetPm
//
//  Created by jyv on 1/21/18.
//  Copyright © 2018 Info JYV Inc. All rights reserved.
//

import Foundation
public class Status: BaseRec {
    @objc dynamic var databaseVersion = 1
    @objc dynamic var lastSyncDate = dateMin()
}
