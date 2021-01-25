//
//  TrackViewController.swift
//  Music Room 3
//
//  Created by ML on 25/01/2021.
//

import UIKit

class TrackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        print(" Track View Controller")
        let trackNumber = UserDefaults.standard.integer(forKey: "TrackNumber") // trackNumber
        let track = ResearchResults.shared.tracks[trackNumber].title // track
        let imageUrl = ResearchResults.shared.tracks[trackNumber].imageUrl // imageUrl
        trackTitle.text = track
        trackImage.image = UIImage(url: URL(string: imageUrl))

    }
    
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
}
