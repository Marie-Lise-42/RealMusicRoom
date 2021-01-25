//
//  PlaylistEditorViewController.swift
//  Music Room 3
//
//  Created by ML on 24/11/2020.
//

import UIKit

extension UIImage {
  convenience init?(url: URL?) {
    guard let url = url else { return nil }
            
    do {
      self.init(data: try Data(contentsOf: url))
    } catch {
      print("Cannot load image from url: \(url) with error: \(error)")
      return nil
    }
  }
}

class PlaylistEditorViewController: UIViewController, UITableViewDelegate, MyCustomCellDelegator {
    
    func callSegueFromCell(cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("User did tap cell with index: \(indexPath.row)")
            UserDefaults.standard.setValue(indexPath.row, forKey: "TrackNumber")

        }
        print("fonction call segue from cell is called")
        self.performSegue(withIdentifier: "TrackSegue", sender: nil)
    }
    

    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.isHidden = true
        // cellules customisées
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // supprimer la liste si elle existe déjà

    }
    
    let control = UIRefreshControl()

    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                  bundle: nil)
        self.tableView.register(textFieldCell,
                                forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let search = self.searchText.text
        print("l'utilisateur veut qu'on cherche : " + search!)
        MakeSearch.shared.makeSearch(userText: search!) { (success) in
            if success {
                print("success")
                print(ResearchResults.shared.printTracks())
                OperationQueue.main.addOperation({
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    if ResearchResults.shared.tracks.count > 0 {
                        self.tableView.isHidden = false
                        _ = ResearchResults.shared.tracks[0].imageUrl //imageUrl
                    } else {
                        self.tableView.isHidden = true
                        // rajouter un message qui dit qu'il n'y a pas de résultat
                    }
                    //imageView.image = UIImage(url: URL(string: "some_url.png"))

                })
            } else {
                print("fail")
            }
        }
    }
}

extension PlaylistEditorViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("nombre d'éléments dans la liste : ", ResearchResults.shared.tracks.count)
        return ResearchResults.shared.tracks.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell
        let track = ResearchResults.shared.tracks[indexPath.row]
        let title = track.title + " - " + track.artist // title
        let imageUrl = track.imageUrl // imageUrl
        cell?.labelCell.text = title
        cell?.imageCell.image = UIImage(url: URL(string: imageUrl))
        cell!.delegate = self
        return cell!
    }
}
