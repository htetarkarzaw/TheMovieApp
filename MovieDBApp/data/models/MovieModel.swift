//
//  MovieModel.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
class MovieModel {
    
    static let shared = MovieModel()
    
    private init() {}
    
    func addWatchMovie(sessionId: String, accountId: Int, movieId: Int, completion : @escaping (ProfileResponse) ->Void) {
        
        let json: [String: Any] = [
            "media_type" : "movie",
            "media_id" : movieId,
            "watchlist": true]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let route = URL(string: Routes.getAddWatchMovie(accountId: accountId, sessionId: sessionId))!
        
        print("route \(movieId)   \(route)")
        var request = URLRequest(url: route)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")        // the expected response is also JSON
        
        request.httpBody = jsonData
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            let response : ProfileResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            
            if let data = response {
                completion(data)
            }
            
            }.resume()
    }
    
    func addRateMovie(sessionId: String, movieId: Int, rateValue: Double, completion : @escaping (ProfileResponse) -> Void) {
        
        let json: [String: Any] = [
            "value" : rateValue
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let route = URL(string: Routes.getAddRateMovie(sessionId: sessionId, movieId: movieId))!
        
        var request = URLRequest(url: route)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        print("\(request)")
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            
            let response : ProfileResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            
            if let data = response {
                completion(data)
            }
            
            }.resume()
        
    }
    
    func fetchWatchMovies(accountId: Int,sessionId: String, completion : @escaping ([MovieInfoResponse]) -> Void) {
        
        let route = URL(string: Routes.getWatchMovies(accountId: accountId, sessionId: sessionId))!
        
        print("route !!!! \(route)")
        URLSession.shared.dataTask(with: route) { (data, urlresponse, error) in
            
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlresponse, error: error)
            
            if let data = response {
//                print("count !! \(data.results.count) \(data.results[0].id)")
                completion(data.results)
            }
            }.resume()
    }
    
    func fetchRatedMovies(accountId: Int, sessionId: String, completion : @escaping ([MovieInfoResponse]) -> Void) {
        
        let route = URL(string: Routes.getRatedMovies(accountId: accountId, sessionId: sessionId ))!
        
        URLSession.shared.dataTask(with: route) { (data, urlresponse, error) in
            
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlresponse, error: error)
            
            if let data = response {
                completion(data.results)
            }
            }.resume()
    }
    
    func fetchMoviesByName(movieName : String, completion : @escaping ([MovieInfoResponse]) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_SEACRH_MOVIES)?api_key=\(API.KEY)&query=\(movieName.replacingOccurrences(of: " ", with: "%20") )")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
            }
            }.resume()
    }
    
    func fetchMovieDetails(movieId : Int, completion: @escaping (MovieInfoResponse) -> Void) {
        let route = URL(string: "\(Routes.ROUTE_MOVIE_DETAILS)/\(movieId)?api_key=\(API.KEY)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieInfoResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func fetchTopRatedMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_TOP_RATED_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
        
    }
    
    func fetchSimilarMovies(movieId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: Routes.getSimilarMovies(movieId: movieId))!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
        
    }
    
    func fetchNowPlayingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_NOW_PLAYING_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
        
    }
    
    func fetchUpComingMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_UP_COMNG_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
        
    }
    
    func fetchPopularMovies(pageId : Int = 1, completion : @escaping (([MovieInfoResponse]) -> Void) )  {
        let route = URL(string: "\(Routes.ROUTE_POPULAR_MOVIES)&page=\(pageId)")!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                //                print(data.results.count)
                completion(data.results)
                
            } else {
                completion([MovieInfoResponse]())
            }
            }.resume()
        
    }
    
    func fetchMovieGenres(completion : @escaping ([MovieGenreResponse]) -> Void ) {
        
        let route = URL(string: Routes.ROUTE_MOVIE_GENRES)!
        let task = URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieGenreListResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data.genres)
            }
        }
        task.resume()
    }
    
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        //        let response = urlResponse as! HTTPURLResponse
        
        //        if response.statusCode == 200 {
        //            guard let data = data else {
        //                print("\(TAG): empty data")
        //                return nil
        //            }
        //
        //            if let result = try? JSONDecoder().decode(T.self, from: data) {
        //                return result
        //            } else {
        //                print("\(TAG): failed to parse data")
        //                return nil
        //            }
        //        } else {
        //            print("\(TAG): Network Error - Code: \(response.statusCode)")
        //            return nil
        //        }
        
        guard let data = data else {
            print("\(TAG): empty data")
            return nil
        }
        
        if let result = try? JSONDecoder().decode(T.self, from: data) {
            return result
        } else {
            print("\(TAG): failed to parse data")
            return nil
        }
    }
    
}
