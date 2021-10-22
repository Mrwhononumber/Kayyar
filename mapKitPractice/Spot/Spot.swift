//
//  Spot.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/18/21.
//

import Foundation
import Firebase
import MapKit

class Spot {
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var kayyarMessage: String
    var dangerLevel: Double
    var numberOfReviews: Int
    var postingUserID: String
    
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["address":address, "latitude": latitude, "longitude": longitude, "kayyarMessage": kayyarMessage, "dangerLevel":dangerLevel, "numberOfReviews":numberOfReviews, "postingUserID": postingUserID, "documentID":documentID]
    }
    
    init(address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, kayyarMessage: String, dangerLevel: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.kayyarMessage = kayyarMessage
        self.dangerLevel = dangerLevel
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(address: "", latitude: 0.0, longitude: 0.0, kayyarMessage: "", dangerLevel: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let kayyarMessage = dictionary["kayyarMessage"] as! String? ?? ""
        let dangerLevel = dictionary["dangerLevel"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
//        let documentID = dictionary["documentID"] as! String
       
        self.init(address: address, latitude: latitude, longitude: longitude, kayyarMessage: kayyarMessage, dangerLevel: dangerLevel, numberOfReviews: numberOfReviews, postingUserID: postingUserID, documentID: "")
    }
    
    
    
    
    
    func saveData(complition: @escaping (Bool) -> ()) {
        
        
        let db = Firestore.firestore()
        
        // check if we have a postingUserID for safety
        guard let postingUserID = Auth.auth().currentUser?.uid else
        { print ("ERROR: Couldn't save data, we don't have a valid postingUserID")
            return complition(false)
            
        }
        self.postingUserID = postingUserID
        
        // Create the dictionary representing the data we want to save
        let dataToSave: [String:Any] = self.dictionary
        // check if the document is new or it has been saved before
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print ("ERROR: adding document \(error?.localizedDescription)")
                    return complition(false)
                }
                self.documentID = ref!.documentID
                print(" Added document\(self.documentID)")
                complition(true)
            }
            // in this case the documet has been saved before so we need to update it
        } else {
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { error in
                guard error == nil else {
                    print ("ERROR: updating document \(error?.localizedDescription)")
                    return complition(false)
                }
                print(" Updated document\(self.documentID)")
                complition(true)
            }
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}
