//
//  OuterTableViewCell.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit

class OuterTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMovie: UILabel!
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    var delegate : ShowDetailDelegate?
    var mData: [MovieVO]? {
        didSet {
            innerCollectionView.reloadData()
        }
    }
    
    var mLabel: String?{
        didSet{
            lblMovie.text = mLabel
        }
    }
    
    var mDelegate: ShowDetailDelegate?{
        didSet{
            delegate = mDelegate
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let flowLayout = self.innerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        innerCollectionView.collectionViewLayout = flowLayout
        
        innerCollectionView.registerForCollectionCell(strID: String(describing: InnerCollectionViewCell.self))

        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension OuterTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.onClickDetail(id: mData?[indexPath.row].id ?? 0)
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc = storyboard.instantiateViewController(withIdentifier:DetialViewController.identifier) as? DetialViewController
//        vc?.movieId = mData?[indexPath.row].id
//        
//        if let viewController = vc {
//            UIApplication.shared.keyWindow?.rootViewController?.present(viewController, animated: true, completion: nil)
//            
//        }
    }
}

extension OuterTableViewCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InnerCollectionViewCell.self), for: indexPath) as! InnerCollectionViewCell
        cell.mData = self.mData?[indexPath.row]

        return cell
    }
    
    
}

extension OuterTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width * 1/3.5;
        if mData?.count == 0 {
            return CGSize(width: width, height: 0)
        }

        return CGSize(width: width, height: width + (width/2))
        
    }
}
