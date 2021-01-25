//
//  ConnectionViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class ConnectionViewController: UIViewController {

    override func viewDidLoad() {
        print("Connection View Did Load")
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        
        self.navigationController?.isNavigationBarHidden = false
        GIDSignIn.sharedInstance()?.presentingViewController = self
        let loggued: Bool = UserDefaults.standard.bool(forKey: "logued")
        if loggued == true {
            performSegue(withIdentifier: "validateLogIn", sender: self)
        }
        self.activityIndicator.isHidden = true
    }
    
    
    /*
     
                FACEBOOK CONNEXION
     
     */
    
    @IBAction func facebookConnect(_ sender: Any) {
        print("On vient de taper sur le bouton de connexion à FaceBook")
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            Profile.loadCurrentProfile { (profile, error) in
                print("on load le profil : ", Profile.current?.name ?? "")
                //self?.updateMessage(with: Profile.current?.name)
            }
            if AccessToken.current == nil {
                print("token is nil")
            } else {
                let token = AccessToken.current
                print("for facebook, we have a token : ")
                self?.getMail(token: token!.tokenString)
                print(token!.tokenString)
                let token2 = token?.tokenString ?? ""
                UserDefaults.standard.setValue(token2, forKey: "FacebookToken")
                UserDefaults.standard.setValue(token2, forKey: "FbToken")
                LogIn.shared.getFacebookLog() { (success) in
                    if success == 1 {
                        UserDefaults.standard.set(true, forKey: "FacebookLoggued")
                        UserDefaults.standard.set(true, forKey: "logued")
                        
                        // ce segue fait buguer l'app sur device ? 
                        self?.performSegue(withIdentifier: "validateLogIn", sender: self)
                    } else {
                        self?.presentAlertInternalError()
                    }
                }
            }
        }
    }
        
    func getMail(token: String) {
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters:  ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
        print("\(result ?? "")")
        })
    }
        
    @IBAction func googleConnect(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
        // cacher le bouton
    }
    
    @objc private func userDidSignInGoogle(_ notification: Notification) {
                
        LogIn.shared.getGoogleLog() { (success) in
            print(success)
            
            if success == 1 {
                UserDefaults.standard.set(true, forKey: "logued")
                UserDefaults.standard.set(true, forKey: "Googlelogued")
                //print("on a bien loggué l'user google ICI")
                if let _ = GIDSignIn.sharedInstance()?.currentUser {
                    //print("ON A UN CURRENT USER ???")
                    self.performSegue(withIdentifier: "validateLogIn", sender: self)
                }
            } else if success == 0 {
                self.presentAlert()
                self.activityIndicator.isHidden = true
            } else if success == 2 {
                self.presentAlertUnactivatedAccount()
                self.activityIndicator.isHidden = true
            } else if success == 3 {
                self.presentAlertInvalidMail()
                self.activityIndicator.isHidden = true
            }
        }
    }
    
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
       
       var returnValue = true
       let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
       
       do {
           let regex = try NSRegularExpression(pattern: emailRegEx)
           let nsString = emailAddressString as NSString
           let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
           
           if results.count == 0
           {
               returnValue = false
           }
           
       } catch let error as NSError {
           print("invalid regex: \(error.localizedDescription)")
           returnValue = false
       }
       
       return  returnValue
   }
    
    @IBAction func validateLog(_ sender: Any) {
        
        let email:String = mailField.text ?? ""
        let validMail = isValidEmailAddress(emailAddressString: email)
        self.activityIndicator.isHidden = false
        self.validateButton.isHidden = true
        let password: String = passwordField.text ?? ""
        
        if validMail == false {
            self.presentAlertWrongMail()
            self.activityIndicator.isHidden = true
            self.validateButton.isHidden = false
        } else {
            LogIn.shared.getlog(email: email, password: password) { (success) in
                print(success)
                if success == 1 {
                    UserDefaults.standard.set(true, forKey: "logued")
                    UserDefaults.standard.set(true, forKey: "MailLogued")
                    self.performSegue(withIdentifier: "validateLogIn", sender: self)
                } else {
                    if success == -1 {
                        self.presentAlertInvalidMail()
                    } else if success == -2 {
                        self.presentAlertUnactivatedAccount()
                    } else if success == -3 {
                        self.presentAlertWrongPassword()
                    } else if success == -4 {
                        self.presentAlertInternalError()
                    }
                    self.presentAlert()
                    self.activityIndicator.isHidden = true
                    self.validateButton.isHidden = false
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "validateLogIn" {
            let _ = segue.destination as! UITabBarController
            //let _ = segue.destination as! ProfileViewController
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Mauvaise combinaison Email/Mot de passe", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertWrongMail() {
        let alertVC = UIAlertController(title: "Erreur", message: "Votre mail n'a pas le bon format", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertInvalidMail() {
        let alertVC = UIAlertController(title: "Erreur", message: "Aucun compte existant avec cet addresse mail", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertUnactivatedAccount() {
        let alertVC = UIAlertController(title: "Erreur", message: "Votre compte n'est pas encore activté.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertWrongPassword() {
        let alertVC = UIAlertController(title: "Erreur", message: "Votre mot de passe n'est pas bon.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertInternalError() {
        let alertVC = UIAlertController(title: "Erreur", message: "Il semble que nous avons des problèmes internes, désolé", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
