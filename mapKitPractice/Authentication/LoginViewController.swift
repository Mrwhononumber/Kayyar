//
//  LoginViewController.swift
//  Basem's Movie Guide Re-issued
//
//  Created by Basem El kady on 10/4/21.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupElements()
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        
        // validate the fileds
        
        let error = validateFields()
        if error != nil {
            showError(error!)
        } else {
            // Create cleaned version of email and password
            let cleanedEmail = emailTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = passwordTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // sign in the user
            Auth.auth().signIn(withEmail: cleanedEmail, password: cleanedPassword) { Result, err in
                // check if there is an error
                if err != nil {
                    self.showError(err!.localizedDescription)
                } else {
                    // transition to HomeScreen
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
                
            }
            
            
           
            
        }
        
        
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InitialScreen") as! HomeViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true, completion:nil)
    }
    
 
    
  
 
    //MARK: - Fields Validation
    
    func validateFields()-> String? {
        // Check if all fields are filled in
        if emailTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill all fields"
        }
        return nil
        
    }
    
    
  
    func showError(_ message:String) {
        errorTextLabel.text = message
    }
    
    //MARK: - Setup UI Elements
    
    func setupElements(){
        CustomUI.styleTextField(emailTextLabel)
        CustomUI.styleTextField(passwordTextLabel)
        CustomUI.styleFilledButton(loginButton)
        CustomUI.styleHollowButton(backButton)
    }
    
    

}
