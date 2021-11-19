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
    var city: String
    var address: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var kayyarMessage: String
    var dangerLevel: Double
    var numberOfReviews: Int
    var postingUserID: String
    var submitionDateString: String
    var submitionDateObject: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy h:mm a"
        return formatter.date(from: submitionDateString)!
        
       
    }
    var spotLocation: CLLocation { return CLLocation(latitude: latitude, longitude: longitude)}
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["city": city, "address":address, "latitude": latitude, "longitude": longitude, "kayyarMessage": kayyarMessage, "dangerLevel":dangerLevel, "numberOfReviews":numberOfReviews, "postingUserID": postingUserID, "submitionDate": submitionDateString, "documentID":documentID]
    }
    
    init(city: String, address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, kayyarMessage: String, dangerLevel: Double, numberOfReviews: Int, postingUserID: String, submitionDate: String, documentID: String) {
        self.city = city
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.kayyarMessage = kayyarMessage
        self.dangerLevel = dangerLevel
        self.numberOfReviews = numberOfReviews
        self.submitionDateString = submitionDate
        self.postingUserID = postingUserID
        
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(city: "", address: "", latitude: 0.0, longitude: 0.0, kayyarMessage: "", dangerLevel: 0.0, numberOfReviews: 0, postingUserID: "", submitionDate: "", documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let city = dictionary["city"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! CLLocationDegrees? ?? 0.0
        let longitude = dictionary["longitude"] as! CLLocationDegrees? ?? 0.0
        let kayyarMessage = dictionary["kayyarMessage"] as! String? ?? ""
        let dangerLevel = dictionary["dangerLevel"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let submitionDate = dictionary["submitionDate"] as! String? ?? ""
//        let documentID = dictionary["documentID"] as! String
       
        self.init(city: city, address: address, latitude: latitude, longitude: longitude, kayyarMessage: kayyarMessage, dangerLevel: dangerLevel, numberOfReviews: numberOfReviews, postingUserID: postingUserID, submitionDate: submitionDate, documentID: "")
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
                print(" 🤣 🤣 🤣 Added document\(self.documentID)")
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
    
    func updateSpotDangerLevel(review: Review, completion: @escaping () -> ()) {
        let db = Firestore.firestore()
//        let reviewRef = db.collection("spots").document(self.documentID).collection("Reviews").document(review.documentID)
//        reviewRef.getDocument { snapShot, error in
//            guard error == nil else {
//                print ("💩💩💩 Error getting the review data while saving it to the spot\(error?.localizedDescription)")
//                return completion()
//            }
//            let reviewDictionary = snapShot?.data()
//            let kayyarLevel = reviewDictionary?["kayyarLevel"] as! Int? ?? 0
     
        
        self.dangerLevel = Double (review.kayyarLevel) // update the dangerus level value
            let dataToUpdate = self.dictionary  // get a reference to the spot dictionary after updating the value of the danger level
            let spotRef = db.collection("spots").document(self.documentID) // get reference to the spot
            // update the spot
            spotRef.setData(dataToUpdate) { error in
                guard error == nil else {
                    print ("Error happened while updating the spot danger level: \(error?.localizedDescription)")
                    return completion()
            }
                print("Danger level has been updated for\(self.address)")
                completion()
            }
        }
        
        
        
        
        
        
    }
    
    
    
    
    
//}
