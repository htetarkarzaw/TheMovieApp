//
//  CustomerHeaderTableViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class CustomerHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var lblHeader: UILabel!
    var headerTitle: String? {
        didSet {
            lblHeader.text = headerTitle
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
