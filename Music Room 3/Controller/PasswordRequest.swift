//
//  PasswordRequest.swift
//  Music Room 3
//
//  Created by ML on 15/12/2020.
//

import Foundation

class PasswordRequest {
    
    static let shared = PasswordRequest()
    private init() {}
    
    private let url = URL(string: "http://62.34.5.191:45559/api/auth/password")!
    private var task: URLSessionTask?
    
    func askForNewPassword(email: String, callback: @escaping (Bool)-> Void) {

        let url2 = "http://62.34.5.191:45559/api/auth/password" + "?email=" + email
        print("url :")
        print(url2)
        let url3 = URL(string: url2)!
        var request = URLRequest(url: url3)
        request.httpMethod = "GET"
        //let body = "email=" + email

        //request.httpBody = body.data(using: .utf8)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false)
                    return
                }
                if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data) {
                    print("response JSON : ")
                    print(responseJSON)
                    if responseJSON["message"] == "Mail send!" {
                        callback(true)
                        return
                    }
                    else if responseJSON["error"] == "Couldn\'t find the user!" {
                        callback(false)
                        return
                    }
                    else if responseJSON["code"] == "400" {
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
