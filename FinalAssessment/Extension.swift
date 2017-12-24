//
//  Extension.swift
//  FinalAssessment
//
//  Created by Kenny Lim on 12/24/17.
//  Copyright © 2017 Kenny Lim. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension UIImageView {
    func loadImageFromUrl(url : String) {
        
        guard let imageUrl = URL(string: url)
            else { return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: imageUrl) { (data, response, error) in
            
            if let error = error {
                print("Dowload Image Error : \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
        task.resume()
    }
}

