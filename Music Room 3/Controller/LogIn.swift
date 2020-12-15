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

    func getlog(email: String, password: String, callback: @escaping (Bool) -> Void) {
     
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=" + email + "&password=" + password
        print(body)
        
//        let fakeBody = "email=4242@gmail.com&password=42"
        
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
                    if responseJSON["code"] == "400" {
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "402" {
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "200" {
                        callback(true)
                        return
                    }
                    else if responseJSON["code"] == "401" {
                        callback(true)
                        // à changer quand le compte sera activé
                        return
                    }
                    //let token: String = responseJSON["token"] ?? ""
                    //let userId: String = responseJSON["userId"] ?? ""
                    //let err: String = responseJSON["error"] ?? ""
                    //print(token)
                    //print(userId)
                    //print(err)
                    /*if (err != ""){
                        callback(false)
                    }
                    else {
                        callback(true)
                    }*/
                    callback(false)
                    return
                }
            }
        }
        task?.resume()
    }
}
