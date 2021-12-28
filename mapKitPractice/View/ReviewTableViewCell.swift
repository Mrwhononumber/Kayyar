//
//  ReviewTableViewCell.swift
//  mapKitPractice
//
//  Created by Basem El kady on 11/7/21.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewDateLabel: UILabel!
    @IBOutlet weak var reviewBodyLabel: UILabel!
    
    var review: Review! {
        didSet{
            // set the treviewTitle to the username
            reviewBodyLabel.text = review.userReview
            reviewTitleLabel.text = review.reviewUsername
            reviewDateLabel.text = review.reviewDate
        }
    }
}
