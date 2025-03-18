//
//  TableViewCell.swift
//  CoreDemo
//
//  Created by Biene Bryle Sanico on 3/18/25.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
