//
//  SignUpViewController.swift
//  ReferralApp
//
//  Created by Avinash Sivakumar on 2/7/21.
//  Edited by Sumedh Garimella on 2/8/21.
//
import FirebaseAuth
import Firebase
import FirebaseFirestore

import UIKit


class SignUpViewController: UIViewController {
    
    

    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
//        Hides the error label
        errorLabel.alpha = 0
        
        
//        Styles the elements
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    
    
    func validatefields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all necessary fields"
        }
        
        
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Your password is not strong enough. Use both uppercase and lowercase letters, some punctuation, and other appropriate characters to make it secure."
        }
        
        
        return nil
    }
    

    @IBAction func signUpTapped(_ sender: Any) {
        
        

        let error = validatefields()
        
        if error != nil {
            showError(message: error!)
        } else{
            
//            create cleaned versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    self.showError(message: "The user could not be created.")
                } else {
                    
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstname": firstName, "lastname": lastName, "uid" : result!.user.uid ]) { (error) in
                        
                        if error != nil {
                            self.showError(message: "ERROR")
                        }
                    }
                    
                    
                    self.transitionToHome() 
                }
            }
        }
        
        
        
        
    }
    
    
    
    func showError( message:String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
