//
//  ManipulateTrackViewController.swift
//  Music Room 3
//
//  Created by ML on 05/01/2021.
//

import UIKit

class ManipulateTrackViewController: UIViewController {
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Manipulate Track View Controller")
        let trackNumber = UserDefaults.standard.integer(forKey: "TrackNumber") // trackNumber
        let track = ResearchResults.shared.tracks[trackNumber].title // track
        let imageUrl = ResearchResults.shared.tracks[trackNumber].imageUrl // imageUrl
        trackTitle.text = track
        trackImage.image = UIImage(url: URL(string: imageUrl))
    }
        
}
