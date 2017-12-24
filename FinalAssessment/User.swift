//
//  User.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import Foundation

class User {
    var email : String = ""
    var uid : String = ""
    var id : String? = nil
    var profileImageURL: String?
    
    init(email: String, uid: String, id: String?, profileImageURL: String) {
        self.email = email
        self.uid = uid
        self.id = id
        self.profileImageURL = profileImageURL
    }
}



