//
//  ProfileViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }
   
//    private let SpotifyClientID = "39c09e90077544a7a6d71a0fbf058a25"
//    private let SpotifyRedirectURI = URL(string: "musicroom://login")!
//    //private let SpotifyClientID = "619c456a06344392917523af40d61409"
//    //private let SpotifyRedirectURI = URL(string: "SPTLoginSampleAppML://login")!
//
//
//    lazy var configuration: SPTConfiguration = {
//        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
//        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
//        // otherwise another app switch will be required
//
//        configuration.playURI = ""
//
//        // Set these url's to your backend which contains the secret to exchange for an access token
//        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
//        configuration.tokenSwapURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/access_token")
//        configuration.tokenRefreshURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/refresh_token")
//        print("config ok")
//        //print("tokenSwapURL : ", configuration.tokenSwapURL)
//        return configuration
//    }()
//
//    lazy var sessionManager: SPTSessionManager = {
//        let manager = SPTSessionManager(configuration: configuration, delegate: self)
//        print("session manager ok")
//        return manager
//    }()
//
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
//        appRemote.delegate = self
//        return appRemote
//    }()
//
//    private var lastPlayerState: SPTAppRemotePlayerState?
//
//    @IBAction func connectButton(_ sender: Any) {
//        /*
//         Scopes let you specify exactly what types of data your application wants to
//         access, and the set of scopes you pass in your call determines what access
//         permissions the user is asked to grant.
//         For more information, see https://developer.spotify.com/web-api/using-scopes/.
//         */
//        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
//
//        if #available(iOS 11, *) {
//            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
//
//            sessionManager.initiateSession(with: scope, options: .clientOnly)
//            print(sessionManager.session ?? "")
//            print("on a tenté  de se co")
//        } else {
//            // Use this on iOS versions < 11 to use SFSafariViewController
//            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
//        }
//    }
//
//    @IBAction func playPauseButton(_ sender: Any) {
//        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
//            appRemote.playerAPI?.resume(nil)
//        } else {
//            appRemote.playerAPI?.pause(nil)
//        }
//    }
//
//
//    @IBAction func deconnectButton(_ sender: Any) {
//        if (appRemote.isConnected) {
//            appRemote.disconnect()
//        }
//    }
//
//
//
//    func update(playerState: SPTAppRemotePlayerState) {
//        if lastPlayerState?.track.uri != playerState.track.uri {
//            //fetchArtwork(for: playerState.track)
//        }
//        lastPlayerState = playerState
//
//    }
//
//    /*func fetchArtwork(for track:SPTAppRemoteTrack) {
//        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
//            if let error = error {
//                print("Error fetching track image: " + error.localizedDescription)
//            } //else if let image = image as? UIImage {
//                //
//
//            //}
//        })
//    }*/
//
//    func fetchPlayerState() {
//        print("fetchPlayerState")
//        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
//            if let error = error {
//                print("Error getting player state:" + error.localizedDescription)
//            } else if let playerState = playerState as? SPTAppRemotePlayerState {
//                self?.update(playerState: playerState)
//            }
//        })
//    }
//
//    // MARK: - SPTSessionManagerDelegate
//
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        print("session manager did fail with")
//        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
//    }
//
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        print("session manager did renew session")
//
//        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
//    }
//
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//        print("func sessionManager didInitiate session")
//        appRemote.connectionParameters.accessToken = session.accessToken
//        appRemote.connect()
//    }
//
//    // MARK: - SPTAppRemoteDelegate
//
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        appRemote.playerAPI?.delegate = self
//        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
//            if let error = error {
//                print("Error subscribing to player state:" + error.localizedDescription)
//            }
//        })
//        fetchPlayerState()
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        lastPlayerState = nil
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        lastPlayerState = nil
//    }
//
//    // MARK: - SPTAppRemotePlayerAPIDelegate
//
//    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        update(playerState: playerState)
//    }
//
//    // MARK: - Private Helpers
//
//    private func presentAlertController(title: String, message: String, buttonTitle: String) {
//        DispatchQueue.main.async {
//            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
//            controller.addAction(action)
//            self.present(controller, animated: true)
//        }
//    }
//
    @IBAction func delogButton(_ sender: Any) {
     /*   if UserDefaults.standard.bool(forKey: "MailLogued") == true {
            print("On avait un User connecté avec son Mail et Mot de passe")
             UserDefaults.standard.setValue(false, forKey: "logued")
             UserDefaults.standard.setValue(false, forKey: "MailLogued")
         }
       */
       

        // Google User

//        UserDefaults.standard.set(true, forKey: "Googlelogued")
        if UserDefaults.standard.bool(forKey: "Googlelogued") == true {
            GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setValue(false, forKey: "logued")
            UserDefaults.standard.setValue(false, forKey: "Googlelogued")

        }
        
        if let _ = GIDSignIn.sharedInstance()?.currentUser {
            print("On avait un User Connecter avec Google")
            print("on ne va pas jusque la ?????")
            UserDefaults.standard.setValue(false, forKey: "logued")
            print("on a lpus de user google connecté ")
            UserDefaults.standard.setValue(false, forKey: "logued")
            UserDefaults.standard.setValue(false, forKey: "Googlelogued")
           
            GIDSignIn.sharedInstance()?.signOut()


        }
        
        // Manque Fb :)

        if UserDefaults.standard.bool(forKey: "FacebookLoggued") == true {
            print("On avait un User Connecter avec Facebook")
            let loginManager = LoginManager()
            loginManager.logOut()
            UserDefaults.standard.setValue(false, forKey: "FacebookLoggued")
            UserDefaults.standard.setValue(false, forKey: "logued")
        }
        
        // Mail Pasword
        if UserDefaults.standard.bool(forKey: "MailLogued") == true {
            UserDefaults.standard.setValue(false, forKey: "MailLogued")
            UserDefaults.standard.setValue(false, forKey: "logued")
        }
        
        UserDefaults.standard.setValue(false, forKey: "logued")
        UserDefaults.standard.setValue(false, forKey: "Googlelogued")
        UserDefaults.standard.setValue(false, forKey: "FacebookLoggued")
        UserDefaults.standard.setValue(false, forKey: "MailLogued")

        
    }
    
    // on verra + tard
    @IBAction func delog(_ sender: Any) {
        print("Entrée Logout Button")
       /* if UserDefaults.standard.bool(forKey: "MailLogued") == true {
            UserDefaults.standard.set(false, forKey: "logued")
            UserDefaults.standard.set(false, forKey: "MailLogued")
            // faire un unwind... 
        }*/
        
        // pour déco un user google
      /*   UserDefaults.standard.set(false, forKey: "logued")
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

        // Profile => Represents a Facebook Profile
        
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

    }*/
    }
}
