//
//  reviewViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/4/21.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
 
    
    @IBOutlet weak var publishReviewButton: UIButton!
    @IBOutlet weak var reviewAdressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var spotAuthorLabel: UILabel!
    
    @IBOutlet weak var reviewKayyarLevelLabel: UILabel!
    
    @IBOutlet weak var reviewAuthorLabel: UILabel!
    @IBOutlet weak var userReview: UITextView!
    
    @IBOutlet weak var reviewDateLabel: UILabel!
  
    
    var spot: Spot!
    var theUsername: String?
    var userUpVoted = false
    var userDownVoted = false
    var kayyarLevelNewValue: Double!
    var review = Review()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       InitKayyarLevelNewValue()
      
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // update the value of the current username
        getCurrentUsername { username in
            self.theUsername = username
           
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }

  
    func InitKayyarLevelNewValue(){
        kayyarLevelNewValue = spot.dangerLevel
    }
    
    @IBAction func upVoteButtonPressed(_ sender: UIButton) {
        if userUpVoted == false || kayyarLevelNewValue == spot.dangerLevel {
            kayyarLevelNewValue = kayyarLevelNewValue + 1
            
            reviewKayyarLevelLabel.text = String(kayyarLevelNewValue)
            userUpVoted = true
            userDownVoted = false
        } else {
            
            return
        }
    }
    
    
    
    @IBAction func downVotePressed(_ sender: UIButton) {
        if userDownVoted == false || kayyarLevelNewValue == spot.dangerLevel {
            kayyarLevelNewValue -= 1
            reviewKayyarLevelLabel.text = String(kayyarLevelNewValue)
            userDownVoted = true
            userUpVoted = false
            
        } else {
            
            return
        }
        
    }
    
    
    func setupUI() {
        cityLabel.text = spot.city
        reviewAdressLabel.text = spot.address
        spotAuthorLabel!.text = "By @\(spot.spotUsername)"
        reviewDateLabel.text = getCurrentDateAndTimeString()
        reviewKayyarLevelLabel.text = String(spot.dangerLevel)
        reviewAuthorLabel!.text = "@\(theUsername ?? "")"
        
        
        userReview.layer.cornerRadius = 10
        publishReviewButton.layer.cornerRadius = 5
        CustomUI.setupButtonsShadow(button: publishReviewButton)
        
    
    }
    
    
    
    
    
 
    
    @IBAction func publishReviewButtonPressed(_ sender: UIButton) {
        
        review.reviewDate = self.getCurrentDateAndTimeString()
        review.userReview = self.userReview.text
        review.reviewUsername = theUsername ?? "No username"
        review.kayyarLevel = Int(kayyarLevelNewValue)
        review.saveReviewData(spot: self.spot) { (success) in
            if success {
                
                    self.dismiss(animated: true, completion: nil)
                
                // Go back programatically
                
            } else {
                print ("Error saving the review")
            }
        }
        
    }

 
  
    
    
    
    
    

}
