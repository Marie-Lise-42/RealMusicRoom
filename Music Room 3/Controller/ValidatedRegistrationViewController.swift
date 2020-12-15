//
//  ValidatedRegistrationViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit

class ValidatedRegistrationViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextLabel()
    }
    
    private func setTextLabel() {
        let name = ""
        //name = user.login
        label.text = "Merci \(name) ! Ton inscription a bien été prise en compte. Il ne te reste plus qu'à valider ton inscription en cliquant sur le lien que l'on vient de t'envoyer par email :)"
    }
}
