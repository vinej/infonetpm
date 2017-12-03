//
//  BaseEditViewController.swift
//  InfoNetPm
//
//  Created by Jean-Yves Vinet on 2017-11-28.
//  Copyright © 2017 Info JYV Inc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Eureka

class BaseEditViewController: FormViewController {

    var objectName = "not set"
    @objc var object : Object? = nil
    
    public func setInternalObject(_ object : Object) {
        self.object = object
        self.objectName = "\(type(of: object))"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (RealmHelper.isDirty(objectName))
        {
            RealmHelper.audit(self.object!)
        }
    }
}
