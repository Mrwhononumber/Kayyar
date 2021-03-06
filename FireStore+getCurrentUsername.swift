//
//  FireStore+Extension.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/8/21.
//

import UIKit
import Firebase

extension UIViewController {
   
   
   
    func getCurrentUsername(completion: @escaping ( (String) -> Void ) ) {
        let db = Firestore.firestore()
        let CurrentUid = Auth.auth().currentUser?.uid
        let usersCollection = db.collection("users")
        usersCollection.getDocuments(completion: { snapshot, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }

            guard let documents = snapshot?.documents else { return }

            for doc in documents {
//                let uid = doc.documentID
                let uid = doc.get("uid") as? String ?? "No uid"
                let username = doc.get("username") as? String ?? "No Name"
//                print("checking name: \(CurrentUid)")
                if CurrentUid == uid {
//                    print (username)
                    completion(username)
                    break
                } else {
                    
                    completion("Couldn't find username")
                }
            }
        })

        
    }
    
}
