//
//  DetailsViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var pictureImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let ref = Database.database().reference()
    
    var selectedListing = Events.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFromFirebase()
        
    }
    
    @IBAction func deleteBtn(_ sender: Any) {
        self.deleteEvents()
    }
    
    func deleteEvents() {
        ref.child("request").child(selectedListing.requestID).setValue(nil)
    }
    
    func getFromFirebase() {
        
        ref.child("request").child(selectedListing.requestID).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let validData = snapshot.value as? [String:Any],
                let picture = validData["picture"] as? String,
                let name = validData["name"] as? String,
                let location = validData["location"] as? String,
                let date = validData["date"] as? String,
                let venue = validData["venue"] as? String,
                let description = validData["description"] as? String else {return}
            
            
            DispatchQueue.main.async {
                let selectedRequest = Events()
                selectedRequest.picture = picture
                selectedRequest.name = name
                selectedRequest.location = location
                selectedRequest.date = date
                selectedRequest.venue = venue
                selectedRequest.description = description
                
                self.pictureImg.loadImageFromUrl(url: picture)
                self.nameLabel.text = name
                self.locationLabel.text = location
                self.dateLabel.text = date
                self.venueLabel.text = venue
                self.descriptionLabel.text = description
                
                
            }
        }
    }
}
