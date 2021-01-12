//
//  RegistrationViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class RegistrationViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
            
        // fb
        if let token = AccessToken.current, !token.isExpired {
            print("on a un token facebook")
            updateButton(isLoggedIn: true)
        }
        
        self.navigationController?.isNavigationBarHidden = false
        GIDSignIn.sharedInstance()?.presentingViewController = self
        self.activityIndicator.isHidden = true
        self.welcolmeText.isHidden = false
        self.validateText.isHidden = true
        self.googleButton.isHidden = false
        self.facebookButtonOutlet.isHidden = false
        self.startMusicRoom.isHidden = true
        self.ouLabel.isHidden = false
        self.firstNameField.isHidden = false
        self.lastNameField.isHidden = false
        self.pseudoField.isHidden = false
        self.mailField.isHidden = false
        self.passwordField.isHidden = false
        self.subscribeButton.isHidden = false
 
        // Register notification to update screen after user successfully signed in
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(userDidSignInGoogle(_:)),
                                               name: .signInGoogleCompleted,
                                               object: nil)
        
        // Update screen base on sign-in/sign-out status (when screen is shown)
        //updateScreen()
    }
  
    @IBAction func logoutButton(_ sender: Any) {
        print("Entrée Logout Button")
        
        
        // pour déco un user google
         UserDefaults.standard.set(false, forKey: "logued")
         if let _ = GIDSignIn.sharedInstance()?.currentUser {
             print("ON VA DECONNECTER UN USER GOOGLE")
             GIDSignIn.sharedInstance()?.signOut()
             print("OK C'EST FAIT")

         }
         
        
        let loginManager = LoginManager()
        if AccessToken.current != nil {
            print(AccessToken.current!)
        }
        //updateScreen()
        
        loginManager.logOut()

        //supprimé momentanément
        Profile.loadCurrentProfile { (profile, error) in
            let testName = Profile.current?.name
            let testUserID = Profile.current?.userID
            let testOther = Profile.current?.firstName
            print(testName ?? "")
            print(testUserID ?? "")
            print(testOther ?? "")
        }
        
        loginManager.logOut()

        Profile.loadCurrentProfile { (profile, error) in
            let testName = Profile.current?.name
            print(testName ?? "")
            let testUserID = Profile.current?.userID
            print(testUserID ?? "")
            let testOther = Profile.current?.firstName
            print(testOther ?? "")
        }
    }

    @IBOutlet weak var facebookButtonOutlet: UIButton!
    @IBOutlet weak var ouLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var pseudoField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var startMusicRoom: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var welcolmeText: UILabel!
    @IBOutlet weak var validateText: UILabel!
    @IBOutlet weak var googleButton: UIButton!

  
    /*
    mail/password subscription
     */
    @IBAction func subscriteButtonAction(_ sender: Any) {
        
        subscribeButton.isHidden = true
        activityIndicator.isHidden = false
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let pseudo = pseudoField.text!
        let mail = mailField.text!
        let password = passwordField.text!
        let validMail = isValidEmailAddress(emailAddressString: mail)
        
        if firstName == "" || lastName == "" || pseudo == "" || password == "" {
            self.presentAlertEmptyField()
            self.subscribeButton.isHidden = false
            self.activityIndicator.isHidden = true
        } else if validMail == false {
            self.presentAlertWrongMail()
            self.subscribeButton.isHidden = false
            self.activityIndicator.isHidden = true
        } else {
            CreateUser.shared.createNewUser(email: mail, password: password, firstName: firstName, lastName: lastName, pseudo: pseudo) { (success) in
                print(success)
                if success {
                    self.activityIndicator.isHidden = true
                    self.welcolmeText.isHidden = true
                    self.validateText.isHidden = false
                    self.validateText.text = "Ton inscription est validée. Il ne te reste plus qu'à cliquer sur le lien de validation que l'on vient de t'envoyer par mail 😍"
                    self.googleButton.isHidden = true
                    self.facebookButtonOutlet.isHidden = true
                    self.startMusicRoom.isHidden = true
                    self.ouLabel.isHidden = true
                    self.firstNameField.isHidden = true
                    self.lastNameField.isHidden = true
                    self.pseudoField.isHidden = true
                    self.mailField.isHidden = true
                    self.passwordField.isHidden = true
                    self.subscribeButton.isHidden = true
                } else {
                    self.presentAlert()
                }
            }
        }
        
        
    }
    
    /*
     Google Subscription
     */
    @IBAction func GoogleSignInButton(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    private func updateScreenGoogleSuccess() {
        print("update screen google success")
        welcolmeText.isHidden = true
        validateText.isHidden = false
        validateText.text = " Ton inscription a bien été prise en compte. "
        googleButton.isHidden = true
        startMusicRoom.isHidden = false
        facebookButtonOutlet.isHidden = true
        ouLabel.isHidden = true
        activityIndicator.isHidden = true
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        pseudoField.isHidden = true
        mailField.isHidden = true
        passwordField.isHidden = true
        subscribeButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func updateScreenGoogleFailure() {
        print("update screen google failure")
        presentAlertAccountAlreadyInDB()
    }
    
    private func updateScreen() {
        print("Entrée Fonction UpdateScreen")

        print(AccessToken.current ?? "")
        if AccessToken.current == nil {
            print("We don't have token !")
        } else {
            print("UPDATE SCREEN 2 ")
            welcolmeText.isHidden = true
            validateText.isHidden = false
            validateText.text = " Ton inscription a bien été prise en compte. "
            googleButton.isHidden = true
            startMusicRoom.isHidden = false
            facebookButtonOutlet.isHidden = true
            ouLabel.isHidden = true
            activityIndicator.isHidden = true
            firstNameField.isHidden = true
            lastNameField.isHidden = true
            pseudoField.isHidden = true
            mailField.isHidden = true
            passwordField.isHidden = true
            subscribeButton.isHidden = true
            self.navigationController?.isNavigationBarHidden = true
        }
        if let _ = GIDSignIn.sharedInstance()?.currentUser {
            print("UPDATE SCREEN 3 ")
            print("on a bien un user google détecté dans update screen")
            welcolmeText.isHidden = true
            validateText.isHidden = false
            validateText.text = " Ton inscription a bien été prise en compte. "
            googleButton.isHidden = true
            startMusicRoom.isHidden = false
            facebookButtonOutlet.isHidden = true
            ouLabel.isHidden = true
            activityIndicator.isHidden = true
            firstNameField.isHidden = true
            lastNameField.isHidden = true
            pseudoField.isHidden = true
            mailField.isHidden = true
            passwordField.isHidden = true
            subscribeButton.isHidden = true
            self.navigationController?.isNavigationBarHidden = true

        } else {
            print("UPDATE SCREEN 4 ")

            welcolmeText.isHidden = false
            validateText.isHidden = true
            googleButton.isHidden = false
            startMusicRoom.isHidden = true
            facebookButtonOutlet.isHidden = false
            ouLabel.isHidden = false
            activityIndicator.isHidden = true
            firstNameField.isHidden = false
            lastNameField.isHidden = false
            pseudoField.isHidden = false
            mailField.isHidden = false
            passwordField.isHidden = false
            subscribeButton.isHidden = false
            self.navigationController?.isNavigationBarHidden = false
        }
    }
    
    func addUserToDb() {
        CreateUser.shared.addGoogleUser() { (success) in
            if success == 1 {
                // Google User Added in DB
                UserDefaults.standard.setValue(true, forKey: "logued")
                self.updateScreenGoogleSuccess()
            } else if success == 2 {
                // Internal Error - Couldn't add Google User in DB
                self.presentAlertInternError()
                self.updateScreenGoogleFailure()
            } else if success == 3 {
                // Error : Email already assigned to a User
                self.updateScreen() // TEST
                self.presentAlertAccountAlreadyInDB()
            } else if success == 4 {
                // Account Created and Email Send !
                self.presentAlertEmailSend()
            }
            else {
                // Internal Error
                self.presentAlertInternError()
            }
        }
    }
    
    // MARK:- Notification
    @objc private func userDidSignInGoogle(_ notification: Notification) {
        addUserToDb()
        //updateScreen()
    }
    
    
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
}


extension RegistrationViewController {
    
    // Extension for Facebook features

    @IBAction func facebookButton(_ sender: Any) {
        print("Fb Button")
            
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            print("On a un current Token ! ")
            loginManager.logOut()
            self.updateButton(isLoggedIn: false)
        } else {
            print("On N'A PAS DE current Token ! ")

            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    return
                }
                self?.updateButton(isLoggedIn: true)
                Profile.loadCurrentProfile { (profile, error) in
                    //self?.updateMessage(with: Profile.current?.name)
                }
                if AccessToken.current == nil {
                    print("token is nil")
                } else {
                    let token = AccessToken.current
                    print("for facebook, we have a token : ")
                    self?.getMail(token: token!.tokenString)
                    print("token : ", token?.tokenString ?? "")
                    UserDefaults.standard.setValue(token, forKey: "FbToken")
                    CreateUser.shared.createNewFacebookUser(callback: <#T##(Bool) -> Void#>)
                }
                
                self?.updateScreenAfterFBLog()
                UserDefaults.standard.setValue(true, forKey: "logued")
            }
        }
    }
    
    private func getMail(token: String) {
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters:  ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        request.start(completionHandler: { connection, result, error in
            print("\(result ?? "")")

        })
    }
    
    private func updateButton(isLoggedIn: Bool) {
        let title = isLoggedIn ? "Log out " : "Facebook "
        facebookButtonOutlet.setTitle(title, for: .normal)
    }
    
    private func updateScreenAfterFBLog() {
        welcolmeText.isHidden = true
        validateText.isHidden = false
        validateText.text = " Ton inscription a bien été prise en compte. "
        googleButton.isHidden = true
        startMusicRoom.isHidden = false
        facebookButtonOutlet.isHidden = true
        ouLabel.isHidden = true
        activityIndicator.isHidden = true
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        pseudoField.isHidden = true
        mailField.isHidden = true
        passwordField.isHidden = true
        subscribeButton.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
}

extension RegistrationViewController {
    
    // extension for alterts
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Un compte est déjà associé à cette adresse mail :'( ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertWrongMail() {
        let alertVC = UIAlertController(title: "Erreur", message: "Votre adresse email n'est pas au bon format ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertEmptyField() {
        let alertVC = UIAlertController(title: "Erreur", message: "Tous les champs ne sont pas remplis :'( ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertInternError() {
        let alertVC = UIAlertController(title: "Erreur", message: "Désolée, nous avons une erreur en interne, nous ne pouvons pas t'inscrire pour le moment ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertAccountAlreadyInDB() {
        let alertVC = UIAlertController(title: "Erreur", message: "Tu as déjà un compte Music Room, tu peux te connecter directement :) ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func presentAlertEmailSend() {
        let alertVC = UIAlertController(title: "Erreur", message: "Tton compte est bien créé mais il faut que tu le valides en cliquant sur le lien envoyé par mail :) ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    
}
