//
//  Events.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class Events {
    
    var picture : String = ""
    var name : String = ""
    var date : String = ""
    var venue : String = ""
    var location : String = ""
    var description : String = ""
    var requestOwnerUID : String = ""
    var requestID : String = ""
    
    init() {
        
    }
    
    init(picture: String, name: String, date: String, venue: String, location: String, description: String, requestOwnerUID : String){
        
        self.picture = picture
        self.name = name
        self.date = date
        self.venue = venue
        self.location = location
        self.description = description
        self.requestOwnerUID = requestOwnerUID
        
    }
    
    func saveRequestToDatabase(_ requestID: String) {
        let ref = Database.database().reference()
        let requestRef = ref.child("request")
        let currentRequest = requestRef.child(requestID)
        
        let dict = ["picture" : self.picture, "name" : self.name, "date" : self.date, "venue" : self.venue, "location" : self.location, "description" : self.description, "requestOwnerUID" : self.requestOwnerUID] as [String : Any]
        currentRequest.setValue(dict)
    }
}
