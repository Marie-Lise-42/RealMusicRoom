//
//  GoogleSubscriptionViewController.swift
//  Music Room 3
//
//  Created by ML on 16/12/2020.
//

import UIKit
import GoogleSignIn

class GoogleSubscriptionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(googleSubscribe(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        // Update screen base on sign-in/sign-out status (when screen is shown)
        updateScreen()
    }
  
    @IBOutlet weak var validateLabel: UILabel!
    @IBOutlet weak var startingButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    
    func updateScreen() {
        
        if let _ = GIDSignIn.sharedInstance()?.currentUser {
            self.validateLabel.isHidden = true
            self.startingButton.isHidden = true
            self.connectButton.isHidden = false
        } else {
            self.validateLabel.isHidden = false
            self.startingButton.isHidden = false
            self.connectButton.isHidden = true
        }
    }
    
   /* func addUserToDb() {
        CreateUser.shared.addGoogleUser() { (success) in
            if success {
                print("success fonction add google user")
            } else {
                print("failure fonction add google user ")
            }
        }
    }
    */
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        //addUserToDb()
        updateScreen()
    }
    
    @IBAction func googleSubscribe(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}
