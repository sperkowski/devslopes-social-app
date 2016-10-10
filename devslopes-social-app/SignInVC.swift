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
import SwiftKeychainWrapper


class SignInVC: UIViewController {
    @IBOutlet weak var emailField: MaterialField!
    @IBOutlet weak var passwordField: MaterialField!

  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
    }


    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text , let password = passwordField.text {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("STEVE: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["proivder": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                  
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("STEVE: Unable to authenticate with Firebase using email")
                        } else {
                            print("STEVE: Successfully authtencticated with Firebase.")
                            if let user = user {
                                let userData = ["proivder": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
        })
    }


    func completeSignIn(id: String, userData: Dictionary<String, String> ) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("STEVE: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }


}

