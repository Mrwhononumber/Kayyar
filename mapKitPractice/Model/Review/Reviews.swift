//
//  Reviews.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/4/21.
//

import Foundation
import Firebase

class Reviews {
    
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    
    func loadReviewData(spot:Spot, completed: @escaping () -> ()) {
       // add listener that listen and notify you if anychange happened to "spots" collection
        db.collection("spots").document(spot.documentID).collection("reviews").addSnapshotListener { (querySnapshot, error) in
            
            // Check if there is an error
            guard error == nil else {
                print("error adding snapshot listner \(String(describing: error))")
                return completed()
                
            }
            // if there is no errors proceed to the next steps:
           // clear all the data inside spotArray
            self.reviewArray = []
            
            //create dictionaries out of all the documents and appened it to the review array
            for document in querySnapshot!.documents {
                
                let review = Review(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(review)
            }
           completed()
            
        
            
            
        }
        
        
    }
    
    
}
