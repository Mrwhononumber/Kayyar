//
//  HomeViewController.swift
//  Basem's Movie Guide Re-issued
//
//  Created by Basem El kady on 10/4/21.
//

import UIKit

class InitialViewController: UIViewController {
    
    //MARK: - Properties

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupElements()
    }
    
    //MARK: - Helper Functions
    
   private func setupElements() {
        CustomUI.styleFilledButton(signUpButton)
        CustomUI.styleHollowButton(loginButton)
    }
}
