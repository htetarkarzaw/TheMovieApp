//
//  MYoutubeViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class MYoutubeViewController: UIViewController {
    
    @IBOutlet weak var playerView: WKYTPlayerView!
    var movieId : Int?
    static let identifier = "MYoutubeViewController"
    lazy var activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.startAnimating()
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        return ui
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
        
        fetchMovieTrailer()
    }
    
    fileprivate func fetchMovieTrailer() {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for _ in 0...5 {
            
            MovieTrailerModel.shared.fetchTrailerByMovieId(movieId: self.movieId ?? 0) { (movieTrailerList) in
                DispatchQueue.main.async {
                    [weak self] in
                    
                    self?.playerView.load(withVideoId: movieTrailerList[0].key ?? "")
                    
                    self?.activityIndicator.stopAnimating()
                    
                }
            }
        }
        
    }
    
}
