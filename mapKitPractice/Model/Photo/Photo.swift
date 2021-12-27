//
//  Photo.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/9/21.
//

import UIKit
import Firebase
import FirebaseStorage

class Photo {
    
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUsername: String
    var photoDate: String
    var photoURL: String
    var documentID: String
    var dictionary: [String:Any] {
        return ["description": description, "photoUserID": photoUserID, "photoUsername": photoUsername, "photoDate": photoDate, "photoURL": photoURL, "documentID": documentID]
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
        
       
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUsername = dictionary["photoUsername"] as! String? ?? ""
        let photoDate = dictionary["photoUsername"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUsername: photoUsername, photoDate: photoDate, photoURL: photoURL, documentID: "")
        
    }
    
    func savePhotoData(spot: Spot, complition: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
    // Convert photo.image to a Data type so it can be saved in Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print ("Error: couldn't compress the photo.image to Data")
            return
        }
        // Create metadata so we can see the images in the Firestore Storage console
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        // Create file name if necessary
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        // Create a storage reference to upload this image file to the spot's folder
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        // Create an upload task
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { storageMetadata, error in
            if let error = error {
                print("Error:uploading ref \( uploadMetaData): \(error.localizedDescription)")
            }
        }
        uploadTask.observe(.success) { (snapshot) in
                print("Upload to Firestore is Successful!")
           
            // Grab the uploaded photo URl and save it to the Photo class photoURL property
            storageRef.downloadURL { url, error in
                guard error == nil else {
                    print("ERROR: error downloading the photo url \(error?.localizedDescription)")
                    return complition(false)
                }
                guard let url = url else {
                    print("Error: the photo url was found nil even though we have no error!")
                    return complition(false)
                }
                 self.photoURL = "\(url)"
              
                // Save the Photos document in spot.documentID:
                // Create the dictionary representing the data we want to save

                            let dataToSave: [String:Any] = self.dictionary

                let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { error in
                    guard error == nil else {
                        print ("ERROR 👺👺👺: updating document \(String(describing: error?.localizedDescription))")
                        return complition(false)
                    }
                    print(" Updated review document\(self.documentID)")
                    complition(true)

                }
            }
            
           
          
            
            }
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("Error upload task for file\(self.documentID) failed , in spot\(spot.documentID), with error \(error.localizedDescription)")
                complition(false)
        }
        
        }
        
    }
    
    func loadImages(spot: Spot, completion: @escaping (Bool)-> ()) {
        guard spot.documentID != "" else {
            print ("Error: there is no vlid documentID ")
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        storageRef.getData(maxSize: 25 * 1024 * 1024) { Data, error in
            if let error = error {
                print("Error: Error happened while reading data from storrageRef: \(error)")
                return completion(false)
            } else {
                self.image = UIImage(data: Data!) ?? UIImage()
                return completion(true)
            }
            
        }
    }
    
    
}





