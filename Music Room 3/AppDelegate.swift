//
//  AppDelegate.swift
//  Music Room 3
//
//  Created by ML on 23/11/2020.
//

import UIKit
import CoreData
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Google Sign In Button
        GIDSignIn.sharedInstance().clientID = "442900747056-7jahnmert3dmlk3mvuepi4sllb1dm6a4.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
        return true
    }
    
    // Google Sign In Button
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {

        return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Music Room 3")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Google Sign In Button
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            
            // Check for sign in error
            if let error = error {
                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                    print("The user has not signed in before or they have since signed out.")
                } else {
                    print("\(error.localizedDescription)")
                }
                return
            }

        
            let idToken = user.authentication.idToken // Safe to send to the server
            let userId = user.userID                  // For client-side use only!

            print("token !! ")
            print(idToken!)
            print("user Id")
            print(userId!)
        
            // Post notification after user successfully sign in
            NotificationCenter.default.post(name: .signInGoogleCompleted, object: nil)
        }

}

// MARK:- Notification names
// Google Sign In Button
extension Notification.Name {
    
    // Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
