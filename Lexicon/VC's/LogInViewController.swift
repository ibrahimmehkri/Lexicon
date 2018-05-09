//
//  LogInViewController.swift
//  Lexicon
//
//  Created by Ibrahim Mehkri  on 2018-05-01.
//  Copyright © 2018 BigNerdRanch. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func handleLogIn(){
        handleSignIn()
        performSegue(withIdentifier: "toHomeScreen", sender: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case email:
            email.resignFirstResponder()
            password.becomeFirstResponder()
        case password:
            password.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    func handleSignIn(){
        guard let emailAddress = email.text else { return }
        guard let pass = password.text else { return }
        
       
        Auth.auth().signIn(withEmail: emailAddress, password: pass, completion: {user, error in
            if error == nil, user != nil {
                print("sign in successful")
            } else {
                print("Error: \(error?.localizedDescription)")
            }
        })
    }
}
