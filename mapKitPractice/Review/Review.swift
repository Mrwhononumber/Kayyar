//
//  Review.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/4/21.
//

import Foundation
import Firebase

class Review {
    
    var kayyarLevel: Int
    var reviewUsername: String
    var userReview: String
    var reviewDate: String
    var reviewUserID: String
    var documentID: String
    var dictionary: [String: Any] {
        return ["kayyarLevel": kayyarLevel, "reviewUsername": reviewUsername, "userReview": userReview, "reviewDate": reviewDate,"reviewUserID": reviewUserID, "documentID": documentID]
    }
    
    init (kayyarLevel: Int, reviewUsername: String, userReview: String,reviewDate: String, reviewUserID: String, documentID: String){
        self.kayyarLevel = kayyarLevel
        self.reviewUsername = reviewUsername
        self.userReview = userReview
        self.reviewDate = reviewDate
        self.reviewUserID = reviewUserID
        self.documentID = documentID
        
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        self.init (kayyarLevel: 0, reviewUsername: "", userReview: "",reviewDate: "", reviewUserID: reviewUserID, documentID: "")
    }
    convenience init(dictionary: [String: Any]) {
        let kayyarLevel = dictionary["kayyarLevel"] as! Int? ?? 0
        let reviewUsername = dictionary["reviewUsername"] as! String? ?? ""
        let userReview = dictionary["userReview"] as! String? ?? ""
        let reviewDate = dictionary["reviewDate"] as! String? ?? ""
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        self.init(kayyarLevel: kayyarLevel, reviewUsername: reviewUsername, userReview: userReview, reviewDate: reviewDate, reviewUserID: reviewUserID, documentID: documentID)
    }
    
    
    
    func saveReviewData(spot: Spot, complition: @escaping (Bool) -> ()) {
        
        
        let db = Firestore.firestore()
        
     
        
        // Create the dictionary representing the data we want to save
        let dataToSave: [String:Any] = self.dictionary
        // check if the document is new or it has been saved before
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave){ error in
                guard error == nil else {
                    print ("ERROR: adding document \(error?.localizedDescription)")
                    return complition(false)
                }
                self.documentID = ref!.documentID
                print(" 🤣 🤣 🤣 Added review document\(self.documentID) to spot\(spot.address)")
                complition(true)
            }
            // in this case the documet has been saved before so we need to update it
        } else {
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { error in
                guard error == nil else {
                    print ("ERROR: updating document \(error?.localizedDescription)")
                    return complition(false)
                }
                print(" Updated review document\(self.documentID)")
                complition(true)
            }
        }
        
    
        
        
        
    }
    
    
    
    
    
    
}
