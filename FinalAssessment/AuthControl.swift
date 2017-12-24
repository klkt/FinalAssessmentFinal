//
//  AuthControl.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import Foundation

extension NotificationCenter {
    static func appLogin() {
        let authNotification = Notification(name: Notification.Name(rawValue: "AuthLogin"), object: nil, userInfo: nil)
        self.default.post(authNotification)
    }
    static func appLogout() {
        let authNotification = Notification(name: Notification.Name(rawValue: "AuthLogout"), object: nil, userInfo: nil)
        self.default.post(authNotification)
    }
    
}

