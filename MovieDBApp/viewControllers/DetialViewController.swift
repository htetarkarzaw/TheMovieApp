//
//  DetialViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class DetialViewController: UIViewController , RatingDelegate{
    
    @IBOutlet weak var tvMovieDetail: UITableView!
    @IBOutlet weak var ivBackground: UIImageView!
    @IBOutlet weak var ivMovie: UIImageView!
    @IBOutlet weak var ivClose: UIImageView!
    @IBOutlet weak var btnRate: UIButton!
    @IBOutlet weak var btnMyList: UIButton!
    @IBOutlet weak var lblMovieDetail: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblAgeLimit: UILabel!
    
    static let identifier = "DetialViewController"
    var movieDetail : MovieDetailResponse?
    
    var similarMovies: [MovieInfoResponse]?
    
    let realm = try! Realm()
    
    let preference = UDHelper()
    
    var movieId : Int? {
        didSet {
            fetchData()
        }
    }
    
    lazy var rateViewController: RatingPopViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: String(describing: RatingPopViewController.self)) as! RatingPopViewController
        viewController.movieId = self.movieId
        viewController.movieTitle = self.movieDetail?.title
        viewController.delegate = self
            // Add View Controller as Child View Controller
            self.add(asChildViewController: viewController)
        return viewController
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    lazy var activityIndicator : UIActivityIndicatorView = {
        let ui = UIActivityIndicatorView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.startAnimating()
        ui.style = UIActivityIndicatorView.Style.whiteLarge
        return ui
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvMovieDetail.delegate = self
        tvMovieDetail.dataSource = self
        tvMovieDetail.separatorStyle = .none
        tvMovieDetail.backgroundColor = UIColor.clear
        
        tvMovieDetail.registerForCell(strID: String(describing: SimilarTableViewCell.self))
        tvMovieDetail.registerForCell(strID: String(describing: CustomerHeaderTableViewCell.self))
        
        self.tvMovieDetail.addSubview(refreshControl)
        
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
        
        
        ivClose.layer.cornerRadius = 15
        let recg = UITapGestureRecognizer(target: self, action: #selector(onTapClose))
        ivClose.addGestureRecognizer(recg)
        ivClose.isUserInteractionEnabled = true
        
        btnPlay.addTarget(self, action: #selector(onPlayTrailer), for: .touchUpInside)
        btnRate.addTarget(self, action: #selector(onAddRate), for: .touchUpInside)
        btnMyList.addTarget(self, action: #selector(onAddWatchList), for: .touchUpInside)
    }
    
    @objc func onAddRate() {
        //        addMovieToRateList()
        self.updateView(viewController: rateViewController)
    }

    @objc func onAddWatchList() {
        addMovieToWatchList()
    }

    @objc func onPlayTrailer() {
        navigateToYoutubeVC(movieId: movieDetail?.id ?? 1)
    }

    @objc func onTapClose() {
        self.dismiss(animated: true, completion: nil)
    }

    func onTapCancel() {
        self.remove(asChildViewController: rateViewController)
    }

    func onTapRate(rate: Double) {
        onTapCancel()
        addMovieToRateList(rate: rate)
    }
    
    func fetchData() {
        if NetworkUtils.checkReachable() == false {
            
            let movie = realm.object(ofType: MovieDetailVO.self, forPrimaryKey: movieId)
            
            if let mMovie = movie {
                if mMovie.adult {
                    lblAgeLimit.text = "18+"
                } else{
                    lblAgeLimit.text = ""
                }
                
                var releaseDateArr = mMovie.release_date?.split(separator: "-")
                lblReleaseDate.text = String(releaseDateArr?[0] ?? "")
                
                lblDuration.text = "\((mMovie.runtime )/60)h \((mMovie.runtime )%60)m"
                
                lblMovieDetail.text = mMovie.overview
            } else {
                Dialog.showAlert(viewController: self, title: "Error", message: "No off line data available!")
            }
            
        } else {
            
            fetchMovieDetail()
            fetchSimilarMovieList()
            
        }
    }
    
    fileprivate func addMovieToWatchList() {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        MovieModel.shared.addWatchMovie(sessionId: preference.getSessionId(), accountId: preference.getAccountId(), movieId: movieId ?? 0
            , completion: { (response) in
                
                DispatchQueue.main.async { [weak self] in
                    
                    if response.status_code == 1 || response.status_code == 12{
                        MovieInfoResponse.updateMovie(movieId: self?.movieDetail?.id ?? 0, realm: self!.realm, movieType: "watch")
                        
                        self?.showToast(message: "Added \(self?.movieDetail?.title ?? "") to Watch List", font: UIFont.systemFont(ofSize: 13))
                        
                    }
                }
                
        })
    }
    
    fileprivate func addMovieToRateList(rate: Double) {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        MovieModel.shared.addRateMovie(sessionId: preference.getSessionId(), movieId: movieDetail?.id ?? 0, rateValue: rate) { (response) in
            
            DispatchQueue.main.async { [weak self] in
                
                if response.status_code == 1 || response.status_code == 12{
                    MovieInfoResponse.updateMovie(movieId: self?.movieDetail?.id ?? 0, realm: self!.realm, movieType: "rated")
                    
                    self?.showToast(message: "Added \(self?.movieDetail?.title ?? "") to Rate List", font: UIFont.systemFont(ofSize: 13))
                }
            }
            
        }
    }
    
    fileprivate func fetchMovieDetail() {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        MovieDetailModel.shared.fetchMovieDetailById(movieId: self.movieId ?? 0) { (movieDetail) in
            DispatchQueue.main.async {
                [weak self] in
                
                MovieDetailResponse.saveMovieDetail(data: movieDetail, realm: self!.realm)
                self?.movieDetail = movieDetail
                
                self?.displayDetail()
            }
        }
    }
    
    fileprivate func fetchSimilarMovieList() {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        MovieModel.shared.fetchSimilarMovies(movieId: self.movieId ?? 0) { (movies) in
            DispatchQueue.main.async {
                [weak self] in
                
                self?.similarMovies = movies
                
                self?.tvMovieDetail.reloadData()
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.fetchMovieDetail()
        
    }
    
    func displayDetail() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.ivBackground.sd_setImage(with: URL(string:  "\(API.BASE_IMG_URL)\(self?.movieDetail?.poster_path ?? "")"), completed: { (image, error, cachetype, url) in
                
                self?.ivBackground.image = image?.blurred(radius: 20)
                self?.ivMovie.image = image
                
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
                
            })
        }
        
        if movieDetail?.adult ?? false {
            self.lblAgeLimit.text = "18+"
        }
        
        if let releaseDate = movieDetail?.release_date {
            var releaseDateArr = releaseDate.split(separator: "-")
            self.lblReleaseDate.text = "\(releaseDateArr[0])"
        }
        
        
        if let runTime = movieDetail?.runtime {
            self.lblDuration.text = "\((runTime )/60)h \((runTime )%60)m"
        }
        
        if let overview = movieDetail?.overview {
            self.lblMovieDetail.text = overview
        }
    }
    
}

extension DetialViewController : UITableViewDelegate {
    
}

extension DetialViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.bounds.width * (1/3)
        return width + (width/2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "More Like This"
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomerHeaderTableViewCell.self)) as! CustomerHeaderTableViewCell
        cell.backgroundView = nil
        cell.headerTitle = "More Like This"
        return cell
    }
    
    /*
     To set background color of tableviewcell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SimilarTableViewCell.self), for: indexPath) as! SimilarTableViewCell
        
        cell.mData = self.similarMovies
        
        return cell
        
        
    }
    
    
}
