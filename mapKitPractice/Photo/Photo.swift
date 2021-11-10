//
//  Photo.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/9/21.
//

import UIKit
import Firebase

class Photo {
    
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUsername: String
    var photoDate: String
    var photoURL: String
    var documentID: String
    var dictionary: [String:Any] {
        return ["image": image, "description": description, "photoUserID": photoUserID, "photoUsername": photoUsername, "photoDate": photoDate, "photoURL": photoURL, "documentID": documentID]
    }
    
    init (image: UIImage, description: String, photoUserID: String, photoUsername: String, photoDate: String, photoURL: String, documentID: String){
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUsername = photoUsername
        self.photoDate = photoDate
        self.photoURL = photoURL
        self.documentID = documentID
    
    }
    
    convenience init () {
        
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        self.init (image: UIImage(), description: "", photoUserID: photoUserID, photoUsername: "", photoDate: "", photoURL: "", documentID: "")
    
    }
    convenience init(dictionary: [String: Any]){
        
        let image = dictionary["image"] as! UIImage? ?? UIImage()
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUsername = dictionary["photoUsername"] as! String? ?? ""
        let photoDate = dictionary["photoUsername"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        
        self.init(image: image, description: description, photoUserID: photoUserID, photoUsername: photoUsername, photoDate: photoDate, photoURL: photoURL, documentID: "")
        
    }
    
    
    
}


