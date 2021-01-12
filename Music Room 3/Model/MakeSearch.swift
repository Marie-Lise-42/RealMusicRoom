//
//  MakeSearch.swift
//  Music Room 3
//
//  Created by ML on 28/12/2020.
//

import Foundation

struct SpotifyTest: Decodable {
    let tracks: SpotifyTrack
}

struct SpotifyTrack: Decodable {
    let href: String
    let items: [SpotifyItem]
    let limit: Int
    let total: Int
}

struct SpotifyItem: Decodable {
    let artists: [SpotifyArtist]?
    let duration_ms: Int?
    let name: String?
    let album: SpotifyAlbum
}

struct SpotifyArtist: Decodable {
    let name: String?
}

struct SpotifyAlbum: Decodable {
    let images: [SpotifyImage]
}

struct SpotifyImage: Decodable {
    let url: String
}


class MakeSearch {
        
    static let shared = MakeSearch()
    private init() {}
    private var task: URLSessionDataTask?
    
    func makeSearch(userText: String, callback: @escaping (Bool) -> Void) {
        let parameters: [String: String] = ["q":userText, "type":"track", "market": "FR", "limit":"20"]
        var components = URLComponents(string: "https://api.spotify.com/v1/search")!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components.url!)
        let token = UserDefaults.standard.string(forKey: "SpotifyAppToken")!
        print(token)
        let bearer = "Bearer " + token
        request.setValue(bearer, forHTTPHeaderField: "Authorization")
        //request.setValue("Bearer BQDCFd4nP-A3chZMg_E_Z1irDbHWrhEcl59TP2B_j_PR9P3_jDQQPQLX6XBl0x7PJF7xo57j3OP7w-NcLl8", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                (200 ..< 300) ~= response.statusCode,
                error == nil else {
                    callback(false)
                    return
            }
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) //json
                let decoder = JSONDecoder()
                
                ResearchResults.shared.remove()
                
                let test = try decoder.decode(SpotifyTest.self, from: data)
                let count = test.tracks.items.count
                if count > 0 {
                    for i in 0...(count - 1) {
                        let title = test.tracks.items[i].name!
                        let artist = test.tracks.items[i].artists![0].name
                        let duration_ms = test.tracks.items[i].duration_ms!
                        
                        // get the image
                        let imageUrl = test.tracks.items[i].album.images[0].url
                        print("imageUrl = ", imageUrl)
                        
                        _ = Track(title: test.tracks.items[i].name!, artist: artist!, duration: test.tracks.items[i].duration_ms!, imageUrl: imageUrl) // track
                        ResearchResults.shared.add(title: title, artist: artist!, duration: duration_ms, imageUrl: imageUrl)
                    }
                }
                
                
                print("the number of tracks founded is ", test.tracks.items.count)
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            callback(true)
            return
        }
        task.resume()
    }
}
