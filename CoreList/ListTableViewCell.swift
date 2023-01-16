//
//  ListTableViewCell.swift
//  CoreList
//
//  Created by Ahmed Hamam on 11/12/2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var itemToDoLbl: UILabel!{
        didSet{
            itemToDoLbl.font = .italicSystemFont(ofSize: 23)
            itemToDoLbl.textColor     = UIColor.black
            itemToDoLbl.textAlignment = .center
            itemToDoLbl.layer.shadowOpacity = 0.1
            itemToDoLbl.layer.shadowOffset = .zero
            itemToDoLbl.layer.shadowRadius = 1
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
