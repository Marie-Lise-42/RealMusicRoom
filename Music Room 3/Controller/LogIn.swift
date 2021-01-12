//
//  LogIn.swift
//  Music Room 3
//
//  Created by ML on 11/12/2020.
//

import Foundation
import UIKit

class LogIn {
    
    static let shared = LogIn()
    private init() {}
    
    private let url = URL(string: "http://62.34.5.191:45559/api/auth/login")!
    private var task: URLSessionDataTask?

    func getGoogleLog(callback: @escaping (Int) -> Void) {
        
        let googleUrl = URL(string:"http://62.34.5.191:45559/api/auth/login/google")!
        let token: String = UserDefaults.standard.value(forKey: "idToken") as! String
        let clientId = "442900747056-7jahnmert3dmlk3mvuepi4sllb1dm6a4.apps.googleusercontent.com"
        var request = URLRequest(url: googleUrl)
        request.httpMethod = "POST"
        let body = "token=" + token + "&MusicRoom_ID=" + clientId
        print("BODY DE LA REQUËTE !!! ")
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
                        print("status code : ", response.statusCode)
                        print("code : ", responseJSON["code"])
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
                            } else if responseJSON["code"] == "2" {
                                callback(0)
                                return
                            } else if responseJSON["code"] == "3" {
                                callback(0)
                                return
                            }
                        } else {
                            callback(0)
                            return
                        }
                        callback(0)
                        return
                    }
                }
            }
        }
        task?.resume()
    }

    func getlog(email: String, password: String, callback: @escaping (Int/*Bool*/) -> Void) {
     
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=" + email + "&password=" + password
        request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(0)//false)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            callback(1)//true)
                            return
                        }
                        else if response.statusCode == 400 {
                            if responseJSON["code"] == "1" {
                                // invalid user email
                                callback(-1)//false)
                                return
                            } else if responseJSON["code"] == "2" {
                                // account not activated
                                callback(-2)//false)
                                return
                            } else if responseJSON["code"] == "3" {
                                // invalid password
                                callback(-3)//false)
                                return
                            }
                        }
                        else if response.statusCode == 500 {
                            // servor error
                            callback(-4)//false)
                            return
                        }
                        callback(-4)//false)
                        return
                    }
                }
            }
        }
        task?.resume()
    }
}
