//
//  ViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ListingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var eventsList = [Events]()
    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Listing"
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getFromFirebase()
        
    }
    
    func getFromFirebase() {
        ref.child("request").observe(.childAdded) { (snapshot) in
            guard let validData = snapshot.value as? [String:Any],
                let name = validData["name"] as? String,
                let location = validData["location"] as? String
                else {return}
            
            let id = snapshot.key
            
            DispatchQueue.main.async {
                let newRequest = Events()
                newRequest.name = name
                newRequest.location = location
                newRequest.requestID = id
                
                self.eventsList.append(newRequest)
                self.tableView.reloadData()
            }
        }
    }
}

extension ListingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let event: Events
        event = eventsList[indexPath.row]
        
        cell.textLabel?.text = event.name
        
        var subtitleString = ""
        let venue = event.venue
        let location = event.location
        subtitleString = "Venue:\(venue), Location:\(String(describing: location))"
        
        cell.detailTextLabel?.text = subtitleString
        
        return cell
    }
}

extension ListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedListing = eventsList[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailViewController.selectedListing = selectedListing
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}

