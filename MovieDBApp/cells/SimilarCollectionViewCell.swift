//
//  SimilarCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class SimilarCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    var mData: MovieInfoResponse? {
        didSet {
            ivMovie.sd_setImage(with: URL(string:  "\(API.BASE_IMG_URL)\(mData?.poster_path ?? "")"), completed: nil)
            lblName.text = mData?.title
            

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
