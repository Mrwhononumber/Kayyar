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
    var userReview: String
    var reviewDate: String
    var reviewUserID: String
    var documentID: String
    var dictionary: [String: Any] {
        return ["kayyarLevel": kayyarLevel, "userReview": userReview, "reviewDate": reviewDate,"reviewUserID": reviewUserID, "documentID": documentID]
    }
    
    init (kayyarLevel: Int, userReview: String,reviewDate: String, reviewUserID: String, documentID: String){
        self.kayyarLevel = kayyarLevel
        self.userReview = userReview
        self.reviewDate = reviewDate
        self.reviewUserID = reviewUserID
        self.documentID = documentID
        
    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        self.init (kayyarLevel: 0, userReview: "",reviewDate: "", reviewUserID: reviewUserID, documentID: "")
    }
    
    
    
}
