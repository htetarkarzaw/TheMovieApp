//
//  SimilarTableViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class SimilarTableViewCell: UITableViewCell {

    @IBOutlet weak var similarCollectionView: UICollectionView!
    var mData : [MovieInfoResponse]? {
            didSet {
                similarCollectionView.reloadData()
    //            self.contentView.layoutIfNeeded()

            }
        }
        
        override func awakeFromNib() {
            super.awakeFromNib()

            let flowLayout = self.similarCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
            
            similarCollectionView.delegate = self
            similarCollectionView.dataSource = self
            similarCollectionView.collectionViewLayout = flowLayout
            similarCollectionView.backgroundColor = .none
            similarCollectionView.backgroundView = nil
            
            
            similarCollectionView.registerForCollectionCell(strID: String(describing: SimilarCollectionViewCell.self))
          
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

        }
        
    }

    extension SimilarTableViewCell : UICollectionViewDelegate {
        
    }

    extension SimilarTableViewCell : UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return mData?.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SimilarCollectionViewCell.self), for: indexPath) as! SimilarCollectionViewCell
            item.mData = self.mData?[indexPath.row]
            return item
        }
        
     
    }

    extension SimilarTableViewCell : UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = collectionView.bounds.width * (1/3)
            return CGSize(width: width, height: width + (width/2))
        }
       
    }
