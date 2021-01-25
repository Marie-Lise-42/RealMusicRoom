//
//  CreateUser.swift
//  Music Room 3
//
//  Created by ML on 07/12/2020.
//

import Foundation
import UIKit

class CreateUser {

    static let shared = CreateUser()
    private init() {}
    private let url = URL(string: "http://62.34.5.191:45559/api/auth/signup")!
    private let urlG = URL(string: "http://62.34.5.191:45559/api/auth/signup/google")!
    private let FbUrl = URL(string: "http://62.34.5.191:45559/api/auth/signup/facebook")!

    private var task: URLSessionTask?
    
    func addGoogleUser(callback: @escaping (Int/*Bool*/) -> Void) {
        let token: String = UserDefaults.standard.value(forKey: "idToken") as! String
        let clientId = "442900747056-7jahnmert3dmlk3mvuepi4sllb1dm6a4.apps.googleusercontent.com"
        var request = URLRequest(url: urlG)
        request.httpMethod = "POST"
        let body = "token=" + token + "&MusicRoom_ID=" + clientId
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(2) /* An Error occured */
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    if let response = response as? HTTPURLResponse {
                        /*print("Requête Créer user Google : status code = ", response.statusCode, " code : ",  responseJSON["code"]!)*/
                        if response.statusCode == 400 {
                            if responseJSON["code"] == "0" {
                                callback(3) /* An Account already exists with this Mail Adress */
                                return
                            } else {
                                print("code 1")
                                callback(0) /* Intern Error */
                                return
                            }
                        } else if response.statusCode == 201 {
                            print("On a une réponse 201")
                            if responseJSON["code"] == "0" {
                                // User Created + Mail Sent
                                callback(2)
                                return
                            } else if responseJSON["code"] == "1" {
                                // User Created Without Mail
                                callback(1)
                                return
                            }
                        } else if response.statusCode == 500 {
                            // Internal Error
                            callback(0)
                            return
                        }
                    }
                    callback(0)
                    return
                }
            }
        }
        task?.resume()
        
                
    }
    
    func createNewUser(email: String, password: String, firstName: String, lastName: String, pseudo: String, callback: @escaping (Int) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=" + email + "&password=" + password + "&firstName=" + firstName + "&lastName=" + lastName + "&pseudo=" + pseudo
        print(body)
        
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
                        if response.statusCode == 201 {
                            callback(1)
                            return
                        } else if response.statusCode == 400 {
                            if responseJSON["code"] == "0" {
                                // The email is already used for a user
                                callback(2)
                                return
                            } else {
                                // intern error
                                callback(0)
                                return
                            }
                        } else {
                            // intern error
                            callback(0)
                            return
                        }
                    }
                }
            }
        }
        task?.resume()
    }

    func createNewFacebookUser(callback: @escaping (Int) -> Void) {
        var request = URLRequest(url: FbUrl)
        request.httpMethod = "POST"
        
        let token = UserDefaults.standard.string(forKey: "FbToken")!

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
                        if response.statusCode == 201 {
                            callback(1)
                            return
                        } else if response.statusCode == 400 {
                            if responseJSON["code"] == "0" {
                                callback(2)
                                return
                            } else if responseJSON["code"] == "1" {
                                callback(0)
                                return
                            } else if responseJSON["code"] == "2" {
                                callback(0)
                                return
                            }
                        } else {
                            callback(0)
                            return
                        }
                    }
                    print(responseJSON)
                    callback(1)
                    return
                }
            }
        }
        task?.resume()
    }
   
}
