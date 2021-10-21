//
//  SignUpViewController.swift
//  Basem's Movie Guide Re-issued
//
//  Created by Basem El kady on 10/4/21.
//

import UIKit
import Firebase


class SignUpViewController: UIViewController {

    @IBOutlet weak var usenameTextLabel: UITextField!
    @IBOutlet weak var emailTextLabel: UITextField!
    @IBOutlet weak var passwordTextLabel: UITextField!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var sigUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupElemets()
    }
    

    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        
        // Validate the fields
        
        let error = validateFields()
        if error != nil {
            // There is something wrong with the validation, show error message
            showError(error!)
            
        } else {
            
            // create cleaned version of the data
            let cleanedUsername = usenameTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedEmail = emailTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = passwordTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            // Create the user
            Auth.auth().createUser(withEmail: cleanedEmail, password: cleanedPassword) { result, err in
           
                // check for errors
                if err != nil {
                    self.showError("Error creating user")
                } else {
                    // user has been created successfuky, now store the username
                   let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username" : cleanedUsername, "uid": result?.user.uid] ) { err in
                        if err != nil {
                            // Show error message
                            self.showError("error saving username")
                        }
                    }
                    // Transition to the home screen
                    self.performSegue(withIdentifier: "signUpToHome", sender: self)
                    
                }
            }
         
        }

    }
    
    
    @IBAction func BackButtonPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InitialScreen") as! HomeViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true, completion:nil)
    }
    
 
    //MARK: - Fields validation
    
    // Check the fields and validate that the data is correct. If everything is correct, this method returns nil. Otherwise, it returns error message
    
    func validateFields() -> String? {
        
        // Check if all fields are filled in
        if usenameTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "Please fill in all fields."
        }
        
        // check if the password is secure
        
        let cleanedPassword = passwordTextLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if CustomUI.isPasswordValid(cleanedPassword) == false {
            return " Please make sure your password is at least 8 charachters with number and symbol included"
            
        }
        
        
        
        return nil
    }
    
    
    
    func showError(_ message:String) {
        errorTextLabel.text = message
    }
    

   
    
    
    
    //MARK: - Setup UI Elements
    
    func setupElemets(){
        CustomUI.styleTextField(usenameTextLabel)
        CustomUI.styleTextField(emailTextLabel)
        CustomUI.styleTextField(passwordTextLabel)
        CustomUI.styleFilledButton(sigUpButton)
        CustomUI.styleHollowButton(backButton)
    }
    

}


