//
//  PlayerViewController.swift
//  Music Room 3
//
//  Created by ML on 15/01/2021.
//

import UIKit

class PlayerViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    private let SpotifyClientID = "39c09e90077544a7a6d71a0fbf058a25"
    private let SpotifyRedirectURI = URL(string: "musicroomsdkspotify://login")!

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/access_token")
        configuration.tokenRefreshURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/refresh_token")
        print("config made")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()

    private var lastPlayerState: SPTAppRemotePlayerState?


    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    }
    
    /*
     override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState
        if playerState.isPaused {
            //pauseAndPlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            //pauseAndPlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }

    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                //print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                //self?.imageView.image = image
            }
        })
    }

    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                //print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }

    
    
    @IBAction func connectAction(_ sender: Any) {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]

        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scope, options: .clientOnly)
            print("session Manager . initiate Session")
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        appRemote.connect()
        print("on appuie sur le bouton")
        print("appRemote.isConnected: ", appRemote.isConnected)
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    @IBAction func disconnectAction(_ sender: Any) {
        if (appRemote.isConnected) {
            appRemote.disconnect()
        }
    }
    
    
    
    /*
                Protocols
     */
    
    // MARK: - SPTSessionManagerDelegate

    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print("did fail with error")
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("did renew")
        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        print("did initiate session")
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }

    // MARK: - SPTAppRemoteDelegate

    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        lastPlayerState = nil
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        lastPlayerState = nil
    }

    // MARK: - SPTAppRemotePlayerAPIDelegate

    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }

    // MARK: - Private Helpers

    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
    
}
