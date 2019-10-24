//
//  ProfileDetailViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileDetailViewController: UIViewController {
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tvMovies: UITableView!
    let realm = try! Realm()
    
    var movieList : Results<MovieVO>?
    
    var ratedMovieList : [MovieVO]?
    
    var watchMovieList : [MovieVO]?
    
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
    
    let preference = UDHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        tvMovies.delegate = self
        tvMovies.dataSource = self
        tvMovies.separatorStyle = .none
        tvMovies.backgroundColor = UIColor.clear
        tvMovies.registerForCell(strID: String(describing: OuterTableViewCell.self))
        tvMovies.registerForCell(strID: String(describing: CustomerHeaderTableViewCell.self))
        
        //Add RefreshControl
        self.tvMovies.addSubview(refreshControl)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        fetchProfileDetail()
        
        movieList = realm.objects(MovieVO.self)
        
    }
    
    
    fileprivate func fetchProfileDetail() {
        
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            self.lblName.text = preference.getUsername()
            
            loadDataFromDb()
            return
        }
        
        ProfileModel.shared.fetchProfileDetail(sessionId: preference.getSessionId()) { (response) in
            
            DispatchQueue.main.async {[weak self] in
                
                self?.preference.saveUserData(username: response.username ?? "", id: response.id ?? 0)
                self?.lblName.text = response.username
                
                self?.fetchRateMovies()
                self?.fetchWatchMovies()
                
                self?.activityIndicator.stopAnimating()
                
            }
        }
    }
    
    fileprivate func fetchRateMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connectin!")
            
            loadDataFromDb()
            
            return
        }
        
        MovieModel.shared.fetchRatedMovies(accountId: preference.getAccountId(), sessionId: preference.getSessionId()) { (movieList) in
            
            DispatchQueue.main.async { [weak self] in
                movieList.forEach{ movie in
                    MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "rated")
                }
                
                self?.loadDataFromDb()
            }
            
        }
    }
    
    fileprivate func fetchWatchMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connectin!")
            
            loadDataFromDb()
            
            return
        }
        
        MovieModel.shared.fetchWatchMovies(accountId: preference.getAccountId(), sessionId: preference.getSessionId()) { (movieList) in
            
            DispatchQueue.main.async { [weak self] in
                
                movieList.forEach{ movie in

                    MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "watch")
                }
                
                self?.loadDataFromDb()

            }
            
            
        }
    }
    
    func loadDataFromDb() {
        watchMovieList = self.movieList?.filter(NSPredicate(format: "watch == %@", NSNumber(value: true))).map({$0}) ?? []
        
        ratedMovieList = self.movieList?.filter(NSPredicate(format: "rated == %@", NSNumber(value: true))).map({$0}) ?? []
        
        tvMovies.reloadData()
        activityIndicator.stopAnimating()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        fetchProfileDetail()
        refreshControl.endRefreshing()
    }
    
}

extension ProfileDetailViewController: UITableViewDelegate {
    
    
}

extension ProfileDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /*
     To set background color of tableviewcell
     */
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = tableView.bounds.width * (1/3)
        return width + (width/2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CustomerHeaderTableViewCell.self)) as! CustomerHeaderTableViewCell
//        cell.backgroundView = nil
//        
//        if section == 0 {
//            cell.headerTitle = "Rated"
//        } else {
//            cell.headerTitle = "Watch"
//        }
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OuterTableViewCell.self), for: indexPath) as! OuterTableViewCell
        
        if indexPath.section == 0 {
            cell.mData = ratedMovieList
            cell.mLabel = "Rated"
        } else {
            cell.mData = watchMovieList
            cell.mLabel = "Watch"
        }
        return cell
    }
    
}
