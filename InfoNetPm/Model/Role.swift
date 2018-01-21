//
//  Role.swift
//  InfoNetPm
//
//  Created by jyv on 11/26/17.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Define your models like regular Swift classes
public class Role: IPM {
    @objc dynamic var name = ""
    @objc dynamic var desc = ""
    @objc dynamic var rateByHour = 0.0
    @objc dynamic var expectedCostByHour = 0.0
}
