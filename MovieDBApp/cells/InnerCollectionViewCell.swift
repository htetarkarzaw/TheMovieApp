//
//  InnerCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import SDWebImage
class InnerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivMovie: UIImageView!
    
    var mData: MovieVO? {
        didSet {
            ivMovie.sd_setImage(with: URL(string:  "\(API.BASE_IMG_URL)\(mData?.poster_path ?? "")"), completed: nil)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
