//
//  RegistrationViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit
import GoogleSignIn

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        
        // Update screen base on sign-in/sign-out status (when screen is shown)
        updateScreen()
        
    }
    
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var pseudoField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var birthdateField: UITextField!
           
    @IBOutlet weak var welcolmeText: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var validateText: UILabel!
    
    /*
            Sign In With Google Account
     */
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var googleSignOut: UIButton!
    
    @IBAction func GoogleSignOutButton(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signOut()
        updateScreen()
    }
    
    @IBAction func GoogleSignInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func updateScreen() {
        if let _ = GIDSignIn.sharedInstance()?.currentUser {
            mailField.isHidden = true
            passwordField.isHidden = true
            firstnameField.isHidden = true
            pseudoField.isHidden = true
            lastnameField.isHidden = true
            birthdateField.isHidden = true
            button.isHidden = true
            welcolmeText.isHidden = true
            validateText.isHidden = false
            validateText.text = " Ton inscription a bien été prise en compte. "
            googleButton.isHidden = true
            googleSignOut.isHidden = false
            
        } else {
            mailField.isHidden = false
            passwordField.isHidden = false
            firstnameField.isHidden = false
            pseudoField.isHidden = false
            lastnameField.isHidden = false
            birthdateField.isHidden = false
            button.isHidden = false
            welcolmeText.isHidden = false
            validateText.isHidden = true
            googleButton.isHidden = false
            googleSignOut.isHidden = true
        }
    }
    
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        // Update screen after user successfully signed in
        updateScreen()
    }
    
    /*
            Sign In With Google Account
     */
    
    /*
            Sign in with Mail & Password
     */
    
    @IBAction func createUser() {
        let mail = mailField.text!
        let password = passwordField.text!
        let firstName = firstnameField.text!
        let lastName = lastnameField.text!
        let pseudo = pseudoField.text!
        let birthdate = birthdateField.text!
        
        
        CreateUser.shared.createNewUser(email: mail, password: password, firstName: firstName, lastName: lastName, pseudo: pseudo, birthdate: birthdate) { (success) in
            print(success)
            if success {
                self.mailField.isHidden = true
                self.passwordField.isHidden = true
                self.firstnameField.isHidden = true
                self.pseudoField.isHidden = true
                self.lastnameField.isHidden = true
                self.birthdateField.isHidden = true
                self.button.isHidden = true
                self.welcolmeText.isHidden = true
                self.validateText.text = " Ton inscription a bien été prise en compte. Il ne te reste plus qu'à valider ton inscription en cliquant sur le lien que l'on vient de t'envoyer par email :)"
                self.validateText.isHidden = false
                self.googleButton.isHidden = true
            }
            else {
                self.presentAlert()
            }
        }
    }
    
    // modifier : rajouter le cas où c'est une erreur interne !
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Un compte est déjà associé à cette adresse mail :'( ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
