//
//  ProfileViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit

class ProfileViewController: UIViewController {

    //var user: currentUser
    
    @IBOutlet weak var createUserButton: UIButton!
    
    @IBAction func createUserTest() {
        let user = User(context: AppDelegate.viewContext)
        user.mail = "test@gmail.com"
        user.name = "user test"
        user.event = nil
        try? AppDelegate.viewContext.save()
        //currentUSer = user
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //currentUser = User.user
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
