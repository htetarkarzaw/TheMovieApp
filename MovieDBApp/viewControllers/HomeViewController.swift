//
//  HomeViewController.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: BaseViewController{
    
    @IBOutlet weak var tvMovies: UITableView!
    
    let realm = try! Realm()
    var movieList : Results<MovieVO>?
    var nowShowingMovieList : [MovieVO]?
    
    var upComingMovieList : [MovieVO]?
    
    var trendingMovieList : [MovieVO]?
    
    var topRatedMovieList : [MovieVO]?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)),for: .valueChanged)
        refreshControl.tintColor = UIColor.red
        return refreshControl
    }()
    
    private var movieListNotifierToken : NotificationToken?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvMovies.delegate = self
        tvMovies.dataSource = self
        tvMovies.registerForCell(strID: String(describing:OuterTableViewCell.self))
        self.tvMovies.addSubview(refreshControl)
        tvMovies.separatorStyle = .none
        showProgress(message: "Loading!")
        
        initGenreListFetchRequest()
        initMovieDataFetchRequest()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //        clearDB()
        if let movieList = movieList, !movieList.isEmpty {
            
            try! realm.write {
                realm.delete(movieList)
            }
            
            self.fetchPopularMovies()
            self.fetchTopRatedMovies()
            self.fetchNowPlayingMovies()
            self.fetchUpComingMovies()
            self.fetchGenreList()
            
        }
        
    }
    
    private func clearDB() {
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    deinit {
        movieListNotifierToken?.invalidate()
    }
    
    fileprivate func initGenreListFetchRequest() {
        let genres = realm.objects(MovieGenreVO.self)
        if genres.isEmpty {
            fetchGenreList()
        }
        
    }
    
    fileprivate func fetchGenreList() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        MovieModel.shared.fetchMovieGenres{ genres in
            genres.forEach { [weak self] genre in
                DispatchQueue.main.async {
                    MovieGenreResponse.saveMovieGenre(data: genre, realm: self!.realm)
                }
            }
        }
    }
    
    fileprivate func initMovieDataFetchRequest() {
        
        movieList = realm.objects(MovieVO.self)
        
        if movieList?.count == 0 {
            fetchNowPlayingMovies()
            fetchUpComingMovies()
            fetchPopularMovies()
            fetchTopRatedMovies()
        }
        
        //TODO: Setup Realm Notification Observer
        movieListNotifierToken = movieList?.observe{ [weak self] changes in
            
            self?.nowShowingMovieList = self?.movieList?.filter(NSPredicate(format: "now_showing == %@", NSNumber(value: true))).map({$0}) ?? []
            
            self?.upComingMovieList = self?.movieList?.filter(NSPredicate(format: "up_coming == %@", NSNumber(value: true))).map({$0}) ?? []
            
            self?.trendingMovieList = self?.movieList?.filter(NSPredicate(format: "trending == %@", NSNumber(value: true))).map({$0}) ?? []
            
            self?.topRatedMovieList = self?.movieList?.filter(NSPredicate(format: "top_rated == %@", NSNumber(value: true))).map({$0}) ?? []
            
            switch changes {
                
            case .initial:
                
                self?.tvMovies.reloadData()
                self?.hideProgress()
                self?.refreshControl.endRefreshing()
                
                break
            case .update(_, let deletions, let insertions, let modification):
                
                //                self?.outerMovieTableView.performBatchUpdates({
                //
                //                    self?.outerMovieTableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}),with: .automatic)
                //
                //                    self?.outerMovieTableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}),with: .automatic)
                //
                //                    self?.outerMovieTableView.reloadRows(at: modification.map({IndexPath(row: $0, section: 0)}),with: .automatic)
                //
                //                }, completion: nil)
                
                self?.tvMovies.reloadData()
                self?.hideProgress()
                self?.refreshControl.endRefreshing()
                
                break
            case .error(let err):
                print(err.localizedDescription)
                self?.hideProgress()
                self?.refreshControl.endRefreshing()
                
                break
            }
        }
    }
    
    /// Now Playing
    fileprivate func fetchNowPlayingMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for index in 0...5 {
            MovieModel.shared.fetchNowPlayingMovies(pageId: index) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "nowplaying")
                    }
                    self?.hideProgress()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    
    /// Up Coming
    fileprivate func fetchUpComingMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for index in 0...5 {
            MovieModel.shared.fetchUpComingMovies(pageId: index) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "upcoming")
                    }
                    
                    self?.hideProgress()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    
    /// Top Rated
    fileprivate func fetchTopRatedMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for index in 0...5 {
            MovieModel.shared.fetchTopRatedMovies(pageId: index) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "toprated")
                    }
                    
                    self?.hideProgress()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    /// Trending
    fileprivate func fetchPopularMovies() {
        if NetworkUtils.checkReachable() == false {
            Dialog.showAlert(viewController: self, title: "Error", message: "No Internet Connection!")
            return
        }
        
        for index in 0...5 {
            MovieModel.shared.fetchPopularMovies(pageId: index) { [weak self] movies in
                DispatchQueue.main.async { [weak self] in
                    
                    movies.forEach{ movie in
                        MovieInfoResponse.saveMovie(data: movie, realm: self!.realm, movieType: "trending")
                    }
                    
                    self?.hideProgress()
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
}



extension HomeViewController : UITableViewDelegate{
    
}

extension HomeViewController : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if #available(iOS 13.0, *) {
            // use the feature only available in iOS 9
            // for ex. UIStackView
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let width = tvMovies.bounds.width * 1/2.5;
        
        switch indexPath.row {
        case 0:
            if trendingMovieList?.count != 0 {
                return width + (width/2)
            } else {
                return 0
            }
            
        case 1:
            if nowShowingMovieList?.count != 0 {
                return width + (width/2)
            } else {
                return 0
            }
            
        case 2:
            if upComingMovieList?.count != 0 {
                return width + (width/2)
            } else {
                return 0
            }
            
        case 3:
            if topRatedMovieList?.count != 0 {
                return width + (width/2)
            } else {
                return 0
            }
            
        default:
            return UITableView.automaticDimension
            
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OuterTableViewCell.self), for: indexPath) as! OuterTableViewCell
        switch indexPath.row {
        case 0:
            cell.mData = trendingMovieList
            cell.mLabel = "Trending"
            break
        case 1:
            cell.mData = nowShowingMovieList
            cell.mLabel = "Now Showing"
            break
        case 2:
            cell.mData = upComingMovieList
            cell.mLabel = "Up Coming"
            break
        case 3:
            cell.mData = topRatedMovieList
            cell.mLabel = "Top Rated"
            break
        default:
            break
        }
        cell.delegate = self
        return cell;
    }
    
    
}

extension HomeViewController:ShowDetailDelegate{
    func onClickDetail(id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier:DetialViewController.identifier) as? DetialViewController
        vc?.movieId = id
        
        if let viewController = vc {
            navigationController?.title = "New"
            present(viewController, animated: true, completion: nil)
            
        }
    }
    
    
}
