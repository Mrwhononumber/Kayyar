//
//  reviewViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/4/21.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {
    
    //MARK: - Properties
    
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
    let review = Review()
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showKeyboard()
        initKayyarLevelNewValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // update the value of the current username
        updateUsername()
    }
    override func viewDidAppear(_ animated: Bool) {
        setupUI()
    }
    
    //MARK: - Buttons Actions
    
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
    

    @IBAction func PublishButtonPressed(_ sender: UIBarButtonItem) {
        guard userReview.text != "" else {
            myOneButtonAlert(title: "Enter a review", message: "Please make sure to write a review")
            return
        }
        review.reviewDate = getCurrentDateAndTimeString()
        review.userReview = userReview.text
        review.reviewUsername = theUsername ?? "No username"
        review.kayyarLevel = Int(kayyarLevelNewValue)
        review.saveReviewData(spot: spot) { [weak self] success in
            guard let self = self else {return}
            if success {
                self.navigationController?.popViewController(animated: true)
            } else {
                self.myOneButtonAlert(title: "Error", message: "Error happened while saving your review, please try again")
                print ("Error saving the review")
                return
            }
        }
    }
    
    //MARK: - Helper Functions
    
    func setupUI() {
        cityLabel.text = spot.city
        reviewAdressLabel.text = spot.address
        spotAuthorLabel!.text = "By @\(spot.spotUsername)"
        reviewDateLabel.text = getCurrentDateAndTimeString()
        reviewKayyarLevelLabel.text = String(spot.dangerLevel)
        reviewAuthorLabel!.text = "@\(theUsername ?? "")"
        userReview.layer.cornerRadius = 10

    }
    
    private func initKayyarLevelNewValue(){
        kayyarLevelNewValue = spot.dangerLevel
    }
    
    private func updateUsername(){
        getCurrentUsername { [weak self] username in
            guard let self = self else {return}
            self.theUsername = username
        }
    }
    private func showKeyboard(){
        userReview.becomeFirstResponder()
    }
}
