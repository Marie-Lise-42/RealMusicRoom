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
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/access_token")
        configuration.tokenRefreshURL = URL(string: "http://62.34.5.191:45559/spotify/authorization_code/refresh_token")
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
    
    //MARK: - SPTSessionManagerDelegate
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken//
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appRemote.delegate = self
            self.appRemote.connect()
        }
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    //MARK: - SPTAppRemoteDelegate
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        appRemote.playerAPI?.pause({ (status, error) in
      //      self.fetchPlayerState()
        })
    }
    
    
    //MARK: - SPTAppRemotePlayerStateDelegate
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        update(playerState: playerState)
    }
    
    //MARK: - Spotify functions
    
    func updateViewBasedOnConnected() {
        print("update view based on connected")
        if (appRemote.isConnected) {
            /*connectButton.isHidden = true
            disconnectButton.isHidden = false
            connectLabel.isHidden = true
            imageView.isHidden = false
            trackLabel.isHidden = false
            pauseAndPlayButton.isHidden = false*/
        } else {
            /*disconnectButton.isHidden = true
            connectButton.isHidden = false
            connectLabel.isHidden = false
            imageView.isHidden = true
            trackLabel.isHidden = true
            pauseAndPlayButton.isHidden = true*/
        }
    }
    
    func fetchArtwork(for track:SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                //self?.imageView.image = image
//                self?.imgThumbnail.image = image
                //self?.currentItem.cover = image
            }
        })
    }
    
    func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
//            self.lblPlayingArtist.text = playerState.track.artist.name
//            self.lblPlayingTitle.text = playerState.track.name
        }
        lastPlayerState = playerState
        if playerState.isPaused {
//            self.btnPlayPause.setImage(UIImage(systemName: "play.fill"), for: .normal)
//            self.playing = false
//            self.timer?.invalidate()
        } else {
//            self.btnPlayPause.setImage(UIImage(systemName: "pause.fill"), for: .normal)
//            self.playing = true
//            if self.timer == nil {
//                self.startTimer()
            }
        }
       /* self.currentItem.artist = playerState.track.artist.name
        self.currentItem.title = playerState.track.name
        self.currentItem.uri = playerState.track.uri
        self.currentItem.duration = Int64(playerState.track.duration)
        self.currentItem.position = Int64(playerState.playbackPosition)
        let duration: CMTime = CMTimeMake(value: self.currentItem.duration!, timescale: 1000)
        let currentTime: CMTime = CMTimeMake(value: self.currentItem.position!, timescale: 1000)
 */
        //let progress: Double = CMTimeGetSeconds(currentTime)/CMTimeGetSeconds(duration)
       // self.prgPlayingProgress.setProgress(Float(progress), animated: false)
   // }
    
    func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
          //      if let delegate = self!.playerDelegate {
           //         delegate.updateDetails()
             //   }
            }
        })
    }
    
    func spotifyConnect() {
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userReadEmail]

        sessionManager.initiateSession(with: scope, options: .clientOnly)
    }
    
    // END SPOTIFY

//    @IBAction func connectButton(_ sender: Any) {
//        print("connect button")
//        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userReadEmail]
//        sessionManager.initiateSession(with: scope, options: .clientOnly)
//    }
    
//    @IBAction func pauseButton(_ sender: Any) {
//        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
//            appRemote.playerAPI?.resume(nil)
//        } else {
//            appRemote.playerAPI?.pause(nil)
//        }
//
//    }
//    
//    @IBAction func disconnectButton(_ sender: Any) {
//        if (appRemote.isConnected) {
//            appRemote.disconnect()
//        }
//    }
    
    @IBAction func connectButton(_ sender: Any) {
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate, .userReadEmail]
        sessionManager.initiateSession(with: scope, options: .clientOnly)
    }
    @IBAction func playButton(_ sender: Any) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    
    
    
    @IBAction func disconnectButton(_ sender: Any) {
        if (appRemote.isConnected) {
            appRemote.disconnect()
        }
    }
    
}
