//
//  SpotifyToken.swift
//  Music Room 3
//
//  Created by ML on 28/12/2020.
//

import Foundation
import UIKit

class SpotifyToken {
    
    // change name of the struct
    struct SpotifyTokenStruct: Codable {
        var access_token: String
        var token_type: String
        var expires_in: Int
        var scope: String?
    }
    
    static let shared = SpotifyToken()
    private init() {}
    
    private let url = URL(string: "https://accounts.spotify.com/api/token")!
    private var task: URLSessionDataTask?
    

    func getSpotifyToken() {
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let access = "39c09e90077544a7a6d71a0fbf058a25:037820b7577c4f2ca3b2f1fecd517511"
        let access64 = access.toBase64()
        let body = "grant_type=client_credentials"
        request.httpBody = body.data(using: .utf8)
        request.setValue("Basic " + access64, forHTTPHeaderField: "Authorization")
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    return
            }
            DispatchQueue.main.async {
                let decoder = JSONDecoder()
                let sToken = try? decoder.decode(SpotifyTokenStruct.self, from: data)
                //print("Our token for Spotify is : ")
                UserDefaults.standard.setValue(sToken!.access_token, forKey: "SpotifyAppToken")
                //print(UserDefaults.standard.string(forKey: "SpotifyAppToken")!)
            }
        }
        task?.resume()
    }
}
