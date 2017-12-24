//
//  ProfileViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class  ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateBtn: UIButton!
    
    
    var eventsList = [Events]()
    
    var userList = User(email: "", uid: "", id: "", profileImageURL: "")
    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getFromFirebase()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        tappedImage.isUserInteractionEnabled = true
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getFromFirebase() {
        
        if let userID = Auth.auth().currentUser?.uid {
            ref.child("users").child(userID).observe(.value, with: { (snapshot) in
                
                let values = snapshot.value as? [String:Any]
                
                self.nameTextField?.text = values?["name"] as? String
                
                self.emailTextField?.text = values?["email"] as? String
                
                let urlString = values?["profileImageURL"] as? String
                
                guard let string = urlString,
                    let url = URL(string: string) else {return}
                
                let manager = URLSession.shared
                
                let dataTask = manager.dataTask(with: url, completionHandler: { (data, response, error) in
                    if let validData = data {
                        let image = UIImage(data: validData)
                        self.profileImageView.image = image
                    }
                })
                dataTask.resume()
            })
            
        }
        
        
        self.ref.child("request").observe(.childAdded) { (snapshot) in
            guard let validData = snapshot.value as? [String:Any],
                let name = validData["name"] as? String,
                let location = validData["location"] as? String,
                let date = validData["date"] as? String
                else {return}
            
            let id = snapshot.key
            
            DispatchQueue.main.async {
                let newRequest = Events()
                newRequest.name = name
                newRequest.location = location
                newRequest.date = date
                newRequest.requestID = id
                
                self.eventsList.append(newRequest)
                self.tableView.reloadData()
                
            }
            
        }
        
        
        
    }
    func currentUser() {
        let userID = Auth.auth().currentUser
        if userID == Auth.auth().currentUser {
            updateBtn.isHidden = false
            profileImageView.isUserInteractionEnabled = true
        } else
            if userID != Auth.auth().currentUser {
                updateBtn.isHidden = true
                profileImageView.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func saveBtnTapped(_ sender: Any) {
    
        let id = Auth.auth().currentUser?.uid
        let name = nameTextField.text
        let email = emailTextField.text
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("users").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                let profileImageUrl = metadata?.downloadURL()?.absoluteString
                
                self.updateUser(id: id!, name: name!, email: email!, profileImageURL: profileImageUrl!)
                self.presentAlertController()
                
            })
        }
        
    }
    
    func presentAlertController() {
        let alert = UIAlertController(title: "Complete!", message: "Update Successful!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func updateUser(id: String, name: String, email: String, profileImageURL: String) {
        let user = ["id": id,
                    "name": name,
                    "email": email,
                    "profileImageURL": profileImageURL] as [String : Any]
        
        ref.child("users").child(id).setValue(user)
        
        
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        
        NotificationCenter.appLogout()
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userRequest: Events
        userRequest = eventsList[indexPath.row]
        
        cell.textLabel?.text = userRequest.name
        
        var subtitleString = ""
        let location = userRequest.location
        subtitleString = "Location:\(location)"
        
        cell.detailTextLabel?.text = subtitleString
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let selectedListing = eventsList[indexPath.row]
        
        let detailViewController = storyBoard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        detailViewController.selectedListing = selectedListing
        
        self.navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}

