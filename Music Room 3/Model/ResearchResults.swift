//
//  ResearchResults.swift
//  Music Room 3
//
//  Created by ML on 28/12/2020.
//

/*
    This class represents the list results of a track research from the search bar
 */

import Foundation

struct Track {
    var title: String
    var artist: String
    var duration: Int
    var imageUrl: String
}

class ResearchResults {
    static let shared = ResearchResults()
    private init() {}
    
    var tracks: [Track] = []
    
  
    func add(title: String, artist: String, duration: Int, imageUrl: String) {
        let newTrack = Track(title: title, artist: artist, duration: duration, imageUrl: imageUrl)
        tracks.append(newTrack)
        //print("a new track was added ! ")
    }
    
    func printTracks() {
        print("let's print our tracks array !")
        
        let count = self.tracks.count
        print("we have \(count) tracks on our playlist")
        
        if count > 0 {
            for i in 0...(count - 1) {
                let title = tracks[i].title
                let artist = tracks[i].artist
                let duration = tracks[i].duration
                let image = tracks[i].imageUrl
                print("Track n°\(i + 1) : \(title), \(artist), \(duration), \(image)")
                
                
            }
        } else {
            print("there is no track in our playlist ! ")
        }
        
    }
    
    func remove() {
        tracks.removeAll()
        //printTracks()
    }
}
