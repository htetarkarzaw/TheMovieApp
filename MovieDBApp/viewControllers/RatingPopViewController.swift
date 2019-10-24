//
//  RatingPopViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import Cosmos
import RealmSwift

class RatingPopViewController: UIViewController {

    @IBOutlet weak var rateView: CosmosView!
    let preference = UDHelper()
    
    let realm  = try! Realm()

    var movieId : Int?
    var movieTitle : String?
    var delegate: RatingDelegate?
    var rating: Double = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        rateView.didFinishTouchingCosmos = { rating in
            
            self.rating = rating
        }
       
    }
    

    @IBAction func onClickCancel(_ sender: Any) {
        delegate?.onTapCancel()
    }
    
    @IBAction func onClickRate(_ sender: Any) {
        delegate?.onTapRate(rate: self.rating)
    }
    
}
