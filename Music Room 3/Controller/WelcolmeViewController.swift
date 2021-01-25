//
//  WelcolmeViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class WelcolmeViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let loggued: Bool = UserDefaults.standard.bool(forKey: "logued")
        
        // Let's say no user is connected right now
        //loggued = false
        if loggued == true {
            performSegue(withIdentifier: "logSegue1", sender: self)
        }
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(false, forKey: "FacebookLoggued")
        UserDefaults.standard.setValue(false, forKey: "logued")
        UserDefaults.standard.setValue(false, forKey: "Googlelogued")
        UserDefaults.standard.setValue(false, forKey: "MailLogued")
    
        // Check if there if a Facebook User has previously loggued in !
        if let token = AccessToken.current, !token.isExpired {
            // Surement pas la bonne manière 
            print("on a un token facebook")
            UserDefaults.standard.setValue(true, forKey: "FacebookLoggued")
            UserDefaults.standard.setValue(true, forKey: "logued")
        }
        
        // Check if there if a Google User has previously loggued in !
        if let _ = GIDSignIn.sharedInstance()?.currentUser {
            UserDefaults.standard.setValue(true, forKey: "Googlelogued")
            UserDefaults.standard.setValue(true, forKey: "logued")
        }
        
        var loggued: Bool = UserDefaults.standard.bool(forKey: "logued")
      
        // Let's say no user is connected right now
        loggued = false
        
        if loggued == true {
            //print("Logued = ", loggued)
            performSegue(withIdentifier: "logSegue1", sender: self)
        }
    }
    
    @IBAction func existingAccount(_ sender: Any) {
        performSegue(withIdentifier: "logSegue1", sender: self)
    }
    
    @IBAction func unwindToLogPage(segue:UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logSegue1" {
            _ = segue.destination as! ConnectionViewController
        }
    }
}
