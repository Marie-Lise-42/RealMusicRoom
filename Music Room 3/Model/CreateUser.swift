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
        print("Entrée Fonction ADD GOOGLE USER")
        
        let token: String = UserDefaults.standard.value(forKey: "idToken") as! String
        print("TOKEN WE HAVE : ", token)
        let clientId = "442900747056-7jahnmert3dmlk3mvuepi4sllb1dm6a4.apps.googleusercontent.com"
        var request = URLRequest(url: urlG)
        request.httpMethod = "POST"
        let body = "token=" + token + "&MusicRoom_ID=" + clientId
        print("Body for the request : ", body)
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("on a une erreur ici ligne 34")
                    callback(2)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 400 {
                            print("on a une réponse 400")
                            if responseJSON["code"] == "0" {
                                print("code 0")

                                callback(3)
                                return
                            } else if responseJSON["code"] == "1" {
                                print("code 1")
                                callback(2)
                                return
                            } else if responseJSON["code"] == "2" {
                                print("code 2")
                                callback(2)
                                return
                            }
                            callback(2)
                            return
                            // if responseJSON["code"] == "1" {
                        } else if response.statusCode == 201 {
                            print("On a une réponse 201")
                            if responseJSON["code"] == "0" {
                                callback(4)
                                return
                            } else if responseJSON["code"] == "1" {
                                callback(1)
                                return
                            }
                        } else if response.statusCode == 500 {
                            print("on a une réponse 500")
                            callback(2)
                            return
                        }
                    }
                    print("aucun de ces cas")
                    callback(2)
                    return
                    
                    
                    /*if responseJSON["code"] == "400" {
                        print("ICI 1")
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "0" {
                        callback(true)
                        return
                    }
                    else {
                        print("ICI 2")
                        callback(false)
                        return
                    }*/
                }
            }
        }
        task?.resume()
        
                
    }
    
    func createNewUser(email: String, password: String, firstName: String, lastName: String, pseudo: String, callback: @escaping (Bool) -> Void) {
        
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
                    callback(false)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    print(responseJSON)
                    if responseJSON["code"] == "1" {
                        // email déjà associé à un compte
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "0" {
                        // success - user created
                        callback(true)
                        return
                    }
                    else {
                        callback(false)
                        return
                    }
                }
            }
        }
        task?.resume()
    }

    func createNewFacebookUser(callback: @escaping (Bool) -> Void) {
        var request = URLRequest(url: FbUrl)
        request.httpMethod = "POST"
        
        let token = ""
        let body = "token=" + token
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    print(responseJSON)
                    callback(true)
                    return
                }
            }
        }
        task?.resume()
    }
   
}
