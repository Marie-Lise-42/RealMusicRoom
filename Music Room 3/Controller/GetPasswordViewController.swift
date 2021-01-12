//
//  GetPasswordViewController.swift
//  Music Room 3
//
//  Created by ML on 15/12/2020.
//

import UIKit

class GetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.successLabel.isHidden = true
        self.homepageButton.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var mailField: UITextField!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var homepageButton: UIButton!
    
    @IBAction func askToResetPassword(_ sender: Any) {
        mailButton.isHidden = true
        activityIndicator.isHidden = false
        let mail = mailField.text! // what if there is nothin?
        PasswordRequest.shared.askForNewPassword(email: mail) { (success) in
            if success {
                print("success pour demander un nouveau mot de passe")
                self.activityIndicator.isHidden = true
                self.mailField.isHidden = true
                self.mailLabel.isHidden = true
                self.mailButton.isHidden = true
                self.successLabel.isHidden = false
                self.homepageButton.isHidden = false
            } else {
                self.activityIndicator.isHidden = true
                print("defaite pour demander un nouveau mot de passe ")
                self.presentAlert()
                self.mailButton.isHidden = false
            }
        }
    }
    
    private func presentAlert() {
        let alertVC = UIAlertController(title: "Erreur", message: "Ton email n'est pas dans notre base de données 😔", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
