//
//  SignUpViewController.swift
//  Lexicon
//
//  Created by Ibrahim Mehkri  on 2018-04-30.
//  Copyright © 2018 BigNerdRanch. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func ContinueButtonPressed(_ sender: UIButton) {
        handleSignUp()
        func performSegueToReturnBack()  {
            if let nav = self.navigationController {
                nav.popViewController(animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameField:
            usernameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            passwordField.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    @objc func handleSignUp(){
        guard let userName = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
    
        Auth.auth().createUser(withEmail: email, password: pass){user, error in
            if error == nil && user != nil {
                print("User Created!")
            } else {
                print("Error creating user: \(error?.localizedDescription)")
            }
        }
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = userName
        changeRequest?.commitChanges{error in if let err = error{
            print(err.localizedDescription)
        }else{print("User Name is set!")}}
        
        self.dismiss(animated: false, completion: nil)
    }
}

