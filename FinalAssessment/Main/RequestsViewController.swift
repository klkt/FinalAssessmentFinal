//
//  RequestsViewController.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RequestsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var pictureImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var venueTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(requestFormDone))

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pictureImage.isUserInteractionEnabled = true
        pictureImage.addGestureRecognizer(tapGestureRecognizer)
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
            pictureImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }

    @objc func requestFormDone() {
        let ref = Database.database().reference()
        
        guard let requestOwnerUID = Auth.auth().currentUser?.uid
            else {return}
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("users").child("\(imageName).png")
        
        if let uploadData = UIImagePNGRepresentation(self.pictureImage.image!) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                let pictureImageUrl = metadata?.downloadURL()?.absoluteString
                
        
        let name = self.nameTextField.text
        let date = self.dateTextField.text
        let venue = self.venueTextField.text
        let location = self.locationTextField.text
        let description = self.descriptionTextField.text
        let request = ref.child("request")
        let requestID = request.childByAutoId()
    
                let newEvent = Events(picture: pictureImageUrl!, name: name!, date: date!, venue: venue!, location: location!, description: description!, requestOwnerUID: requestOwnerUID)
        
        newEvent.saveRequestToDatabase(requestID.key)
    
            })
            
            
        }
        
        tabBarController?.selectedIndex = 0
    }
}
