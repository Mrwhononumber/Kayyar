//
//  Photos.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/14/21.
//

import Foundation
import Firebase

class Photos {
        
        var photoArray: [Photo] = []
        var db: Firestore!
        
        init(){
            db = Firestore.firestore()
        }
        
        func loadPhotoData(spot:Spot, completed: @escaping () -> ()) {
           // add listener that listen and notify you if anychange happened to "spots" collection
            db.collection("spots").document(spot.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
                
                // Check if there is an error
                guard error == nil else {
                    print("error adding snapshot listner \(error)")
                    return completed()
                    
                }
                // if there is no errors proceed to the next steps:
               // clear all the data inside spotArray
                self.photoArray = []
                
                //create dictionaries out of all the documents and appened it to the review array
                for document in querySnapshot!.documents {
                    
                    let photo = Photo(dictionary: document.data())
                    photo.documentID = document.documentID
                    self.photoArray.append(photo)
                }
               completed()
                
            
                
                
            }
            
            
        }
    
    

    
    
    

}
