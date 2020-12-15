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
    private var task: URLSessionTask?
    
    func createNewUser(email: String, password: String, firstName: String, lastName: String, pseudo: String, birthdate: String, callback: @escaping (Bool) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let body = "email=" + email + "&password=" + password + "&firstName=" + firstName + "&lastName=" + lastName + "&pseudo=" + pseudo + "&birthDate=" + birthdate
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
                    if responseJSON["code"] == "400" {
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "201" {
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
}
