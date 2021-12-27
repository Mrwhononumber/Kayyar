//
//  Spots.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/21/21.
//

import Foundation
import Firebase

class Spots {
    
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init(){
        db = Firestore.firestore()
    }
    



func loadData(completed: @escaping () -> ()) {
   // add listener that listen and notify you if anychange happened to "spots" collection
    db.collection("spots").addSnapshotListener { (querySnapshot, error) in
        
        // Check if there is an error
        guard error == nil else {
            print("error adding snapshot listner \(error)")
            return completed()
            
        }
        // if there is no errors proceed to the next steps:
        // clear all the data inside spotArray
        self.spotArray = []
        
        //
        for document in querySnapshot!.documents {
            
            let spot = Spot(dictionary: document.data())
            spot.documentID = document.documentID
            self.spotArray.append(spot)
        }
       completed()
        
    
        
        
    }
    
    
}




}
