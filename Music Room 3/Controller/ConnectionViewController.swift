//
//  ConnectionViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit

class ConnectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    
    @IBAction func validateLog(_ sender: Any) {
        
        let email:String = mailField.text ?? ""
        let password: String = passwordField.text ?? ""
        
        LogIn.shared.getlog(email: email, password: password) { (success) in
            print(success)
            if success {
                self.performSegue(withIdentifier: "validateLogIn", sender: self)
            } else {
                self.presentAlert()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "validateLogIn" {
            let _ = segue.destination as! UITabBarController
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Mauvaise combinaison Email/Mot de passe", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
