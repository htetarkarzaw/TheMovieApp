//
//  MovieListCollectionViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ivPoster: UIImageView!
    
    var data : MovieVO? {
        didSet {
            if let data = data {
                ivPoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    static var identifier : String {
           return String(describing: self)
       }
}
