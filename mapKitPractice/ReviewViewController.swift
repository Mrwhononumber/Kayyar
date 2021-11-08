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
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        reviewAdressLabel.text = spot.address
        reviewDateLabel.text = getCurrentDateTime()
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        var review = Review()
        review.reviewDate = getCurrentDateTime()
        review.userReview = self.userReview.text
      
        review.saveReviewData(spot: spot) { (success) in
            if success {
                // Go back programatically
                self.navigationController?.popViewController(animated: true)
            } else {
                print ("Error saving the review")
            }
        }
        
    }
    

    
    
 
    
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        
      
        
    }

 
  
    
    
    
    
    

}
