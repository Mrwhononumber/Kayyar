//
//  reviewViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/4/21.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var reviewAdressLabel: UILabel!
    
    @IBOutlet weak var reviewKayyarLevelLabel: UILabel!
    
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
       setupUI()
       InitKayyarLevelNewValue()
      
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // update the value of the current username
        getCurrentUsername { username in
            self.theUsername = username
        }
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
        reviewAdressLabel.text = spot.address
        reviewDateLabel.text = getCurrentDateTime()
        reviewKayyarLevelLabel.text = String(spot.dangerLevel)
        
        
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
       
            review.reviewDate = self.getCurrentDateTime()
            review.userReview = self.userReview.text
            review.reviewUsername = theUsername ?? "No username"
            review.kayyarLevel = Int(kayyarLevelNewValue)
            review.saveReviewData(spot: self.spot) { (success) in
                if success {
                    
                        self.navigationController?.popViewController(animated: true)
                    
                    // Go back programatically
                    
                } else {
                    print ("Error saving the review")
                }
            }
     
    
        
    }
    

    
    
 
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
      
        
    }

 
  
    
    
    
    
    

}
