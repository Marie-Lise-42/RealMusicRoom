//
//  MailRegistrationViewController.swift
//  Music Room 3
//
//  Created by ML on 16/12/2020.
//

import UIKit

class MailRegistrationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.activityIndicator.isHidden = true
        self.validationLabel.isHidden = true
    }
    
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var pseudoField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func button(_ sender: Any) {
        self.buttonOutlet.isHidden = true
        self.activityIndicator.isHidden = false
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let pseudo = pseudoField.text!
        let mail = mailField.text!
        let password = passwordField.text!
        let validMail = isValidEmailAddress(emailAddressString: mail)
        
        if firstName == "" || lastName == "" || pseudo == "" || password == "" {
            self.presentAlertEmptyField()
            self.buttonOutlet.isHidden = false
            self.activityIndicator.isHidden = true
        } else if validMail == false {
            self.presentAlertWrongMail()
            self.buttonOutlet.isHidden = false
            self.activityIndicator.isHidden = true
        } else {
            CreateUser.shared.createNewUser(email: mail, password: password, firstName: firstName, lastName: lastName, pseudo: pseudo) { (success) in
                print(success)
                if success {
                    self.mailField.isHidden = true
                    self.passwordField.isHidden = true
                    self.firstNameField.isHidden = true
                    self.lastNameField.isHidden = true
                    self.pseudoField.isHidden = true
                    self.buttonOutlet.isHidden = true
                    self.validationLabel.isHidden = false
                    self.activityIndicator.isHidden = true
                } else {
                    self.presentAlert()
                }
            }
        }
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
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Un compte est déjà associé à cette adresse mail :'( ", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
