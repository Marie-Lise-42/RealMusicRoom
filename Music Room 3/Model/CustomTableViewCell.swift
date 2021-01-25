//
//  CustomTableViewCell.swift
//  Music Room 3
//
//  Created by ML on 05/01/2021.
//

import UIKit

// pour gérer le bouton
protocol MyCustomCellDelegator {

    func callSegueFromCell(cell: UITableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    
    // pour gérer le bouton
    var delegate:MyCustomCellDelegator!

    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBAction func button(_ sender: Any) {
        
        // pour gérer le bouton
        if(self.delegate != nil){
            self.delegate.callSegueFromCell(cell: self)//myData: nil)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    
}
