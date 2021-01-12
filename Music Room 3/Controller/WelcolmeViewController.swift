//
//  WelcolmeViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit

class WelcolmeViewController: UIViewController {
    
    // Spotify Authentication
    let SpotifyClientID = "39c09e90077544a7a6d71a0fbf058a25"
    let SpotifyRedirectURL = URL(string: "musicroom3://login-callback")!

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("entrée page d'accueil music room")
        print(UserDefaults.standard.bool(forKey: "logued"))
        let loggued: Bool = UserDefaults.standard.bool(forKey: "logued")
        if loggued == true {
            performSegue(withIdentifier: "logSegue1", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    /*    print("entrée dans page d'accueil Music Room !! ")
        let loggued: Bool = UserDefaults.standard.bool(forKey: "logued")
        print(loggued)
        if loggued == true {
            performSegue(withIdentifier: "logSegue1", sender: self)
        }*/
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
