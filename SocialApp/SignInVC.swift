//
//  ViewController.swift
//  SocialApp
//
//  Created by Gabriel Trujillo Gómez on 7/14/17.
//  Copyright © 2017 Gabriel Trujillo Gómez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

class SignInVC: UIViewController
{
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if let _ = KeychainWrapper.standard.string(forKey: USER_UID_KEY)
        {
            performSegue(withIdentifier: "FeedVC", sender: nil)
        }
    }

    @IBAction func fbButtonPressed(_ sender: Any)
    {
        let facebookLoginManager = FBSDKLoginManager()
        facebookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil
            {
                print("Error in facebook auth")
            }
            else if result?.isCancelled == true
            {
                print("Please grant email permissions")
            }
            else
            {
                print("Successfully authenticated with FB")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential: credential)
            }
        }
    }

    @IBAction func signInButtonPressed(_ sender: Any)
    {
        if let email = emailField.text, let password = passwordField.text
        {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil, let user = user
                {
                    print("User was successfully signed in")
                    self.completeSignIn(id: user.uid, wasCreated: false, userData: nil)
                }
                else
                {
                    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error == nil, let user = user
                        {
                            print("User succesfully created and signed in")
                            
                            
                            let userData = ["provider": user.providerID]
                            self.completeSignIn(id: user.uid, wasCreated: true, userData: userData)
                        }
                        else
                        {
                            print("Something went wrong with creating user")
                        }
                    })
                }
            })
        }
    }
    
    func firebaseAuth(credential: AuthCredential)
    {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil
            {
                print("Couldn't authenticate with Firebase, error: \(String(describing: error))")
                return
            }
            if let user = user
            {
                print("User was successfully authenticated with Firebase!")
                
                let userData = ["provider": credential.provider]
                self.completeSignIn(id: user.uid, wasCreated: true, userData: userData)
            }
        }
    }
    
    func completeSignIn(id: String, wasCreated: Bool, userData: Dictionary<String, String>?)
    {
        if wasCreated, let userData = userData
        {
            DataService.instance.createFirebaseDBUser(uid: id, userData: userData)
        }
        let keychainResult = KeychainWrapper.standard.set(id, forKey: USER_UID_KEY)
        print("Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "FeedVC", sender: nil)
    }
}

