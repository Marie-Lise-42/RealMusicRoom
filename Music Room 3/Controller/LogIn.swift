//
//  LogIn.swift
//  Music Room 3
//
//  Created by ML on 11/12/2020.
//

import Foundation
import UIKit

/*
    This Model Send Requests to our Back End APIs to
    Log our users
 
 */

class LogIn {
 
    static let shared = LogIn()
    private init() {}
    
    private var task: URLSessionDataTask?
    
    /* For User that subscribed with their Google Account */
   func getGoogleLog(callback: @escaping (Int) -> Void) {
        let googleUrl = URL(string:"http://62.34.5.191:45559/api/auth/login/google")!
        let token: String = UserDefaults.standard.value(forKey: "idToken") as! String
        let clientId = "442900747056-7jahnmert3dmlk3mvuepi4sllb1dm6a4.apps.googleusercontent.com"
        var request = URLRequest(url: googleUrl)
        request.httpMethod = "POST"
        let body = "token=" + token + "&MusicRoom_ID=" + clientId
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(0)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            callback(1)
                            return
                        } else if response.statusCode == 400 {
                            if responseJSON["code"] == "0" {
                                callback(3)
                                return
                            } else if responseJSON["code"] == "1" {
                                callback(2)
                                return
                            } else if responseJSON["code"] == "2" || responseJSON["code"] == "3" {
                                callback(0)
                                return
                            }
                        } else {
                            callback(0)
                            return
                        }
                    }
                }
            }
        }
        task?.resume()
    }
    
    /* For User that subscribed with a Mail and Password */
    func getlog(email: String, password: String, callback: @escaping (Int) -> Void) {
        
        let url = URL(string: "http://62.34.5.191:45559/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=" + email + "&password=" + password
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(0)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    
                    if let response = response as? HTTPURLResponse {
                        
                        if response.statusCode == 200 {
                            callback(1)
                            return
                        }
                        else if response.statusCode == 400 {
                            if responseJSON["code"] == "1" {
                                callback(-1) /* invalid user email */
                                return
                            } else if responseJSON["code"] == "2" {
                                print("400 code 2 ")
                                callback(-2) /* unactivated account */
                                return
                            } else if responseJSON["code"] == "3" {
                                callback(-3) /* invalid password */
                                return
                            }
                        }
                        else {
                            callback(-4) /* Servor or internal Error */
                            return
                        }
                    }
                }
            }
        }
        task?.resume()
    }

    /* For User that subscribed with their Facebook Account */
    func getFacebookLog(callback: @escaping (Int) -> Void) {
        
        let facebookUrl = URL(string:"http://62.34.5.191:45559/api/auth/login/facebook")!
        let token = UserDefaults.standard.string(forKey: "FacebookToken") ?? ""
        var request = URLRequest(url: facebookUrl)
        request.httpMethod = "POST"
        let body = "token=" + token
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(0)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    if let response = response as? HTTPURLResponse {
                        print("status code : ", response.statusCode, responseJSON["code"] ?? "")
                        if response.statusCode == 200 {
                            callback(1)
                            return
                        } else {
                            callback(0)
                            return
                        }
                    }
                }
            }
        }
        task?.resume()
    }
}
