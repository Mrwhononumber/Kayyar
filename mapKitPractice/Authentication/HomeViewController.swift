//
//  HomeViewController.swift
//  Basem's Movie Guide Re-issued
//
//  Created by Basem El kady on 10/4/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupElements()
    }
    
    //MARK: - Setup UI Elements
    
    func setupElements() {
        CustomUI.styleFilledButton(signUpButton)
        CustomUI.styleHollowButton(loginButton)
    }

   

}
