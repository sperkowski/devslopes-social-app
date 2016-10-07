//
//  ViewController.swift
//  devslopes-social-app
//
//  Created by Steven Perkowski on 10/4/16.
//  Copyright © 2016 Steven Perkowski. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailField: MaterialField!
    @IBOutlet weak var passwordField: MaterialField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text , let password = passwordField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("STEVE: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("STEVE: Unable to authenticate with Firebase using email")
                        } else {
                            print("STEVE: Successfully authtencticated with Firebase.")
                        }
                    })
                }
            })
        }
    }

    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
    
        let facebookLogin = FBSDKLoginManager()
        
        // Facebook auth code
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("STEVE: Unable to authenticate with Facebook! - \(error)")
            } else if result?.isCancelled == true {
                print("STEVE: User cancelled facebook authentication")
            } else {
                print("STEVE: Successfully authenticated with facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    // Firebase auth code
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("STEVE: Unable to authenticate with Firebase - \(error)")
            } else {
                print("STEVE: Successfully authenticated with Firebase")
            }
        })
    }

}

