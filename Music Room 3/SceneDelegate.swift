//
//  SceneDelegate.swift
//  BlindAid
//
//  Created by Nicolas Bouillon on 16/06/2020.
//  Copyright © 2020 Nicolas Bouillon. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootViewController : UINavigationController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
//        rootViewController = (UIApplication.shared.windows.first!.rootViewController as! UINavigationController)
//        if let _ =
//            rootViewController?.TestViewController.appRemote.connectionParameters.accessToken {
//            rootViewController?.TestViewController.appRemote.connect()
//        }
        //spotifyManager.authorize()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        
//        rootViewController = (UIApplication.shared.windows.first!.rootViewController as! WelcolmeViewController)
//
//        if (rootViewController!.TestViewController.appRemote.isConnected) {
//            rootViewController!.TestViewController.appRemote.disconnect()
//        }
        //spotifyManager.deauthorize()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        let rootViewController = (UIApplication.shared.windows.first!.rootViewController as! UINavigationController)

        let vc = rootViewController.topViewController?.children[2] as! PlayerViewController

        if let url = URLContexts.first?.url {
            vc.sessionManager.application(UIApplication.shared, open: url, options: [:])
        }

    }
}


