//
//  Routes.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
class Routes {
    
    static let ROUTE_MOVIE_GENRES = "\(API.BASE_URL)/genre/movie/list?api_key=\(API.KEY)"
    static let ROUTE_TOP_RATED_MOVIES = "\(API.BASE_URL)/movie/top_rated?api_key=\(API.KEY)"
    static let ROUTE_POPULAR_MOVIES = "\(API.BASE_URL)/movie/popular?api_key=\(API.KEY)"
    
    static let ROUTE_MOVIE_DETAILS = "\(API.BASE_URL)/movie"
    static let ROUTE_SEACRH_MOVIES = "\(API.BASE_URL)/search/movie"
    
    static let ROUTE_NOW_PLAYING_MOVIES = "\(API.BASE_URL)/movie/now_playing?api_key=\(API.KEY)"
    static let ROUTE_UP_COMNG_MOVIES = "\(API.BASE_URL)/movie/upcoming?api_key=\(API.KEY)"
   
    static func getSimilarMovies(movieId : Int) -> String {
        let ROUTE_SIMILAR_MOVIES = "\(API.BASE_URL)/movie/\(movieId)/similar?api_key=\(API.KEY)"

        return ROUTE_SIMILAR_MOVIES
    }
    
    static func getDetail(movieId : Int) -> String {
        let ROUTE_SIMILAR_MOVIES = "\(API.BASE_URL)/movie/\(movieId)?api_key=\(API.KEY)"
        
        return ROUTE_SIMILAR_MOVIES
    }
    
    static func getTrailer(movieId : Int) -> String {
        let ROUTE_MOVIE_TRAILER = "\(API.BASE_URL)/movie/\(movieId)/videos?api_key=\(API.KEY)"
        
        return ROUTE_MOVIE_TRAILER
    }
    
    static let ROUTE_REQUEST_TOKEN = "\(API.BASE_URL)/authentication/token/new?api_key=\(API.KEY)"
    
    static let ROUTE_VALIDATE_LOGIN = "\(API.BASE_URL)/authentication/token/validate_with_login?api_key=\(API.KEY)"
    
    static let ROUTE_CREATE_SESSION = "\(API.BASE_URL)/authentication/session/new?api_key=\(API.KEY)"
    
    static func getAccountDetail(sessionId: String) -> String{
        let ROUTE_ACCOUNT_DETAIL = "\(API.BASE_URL)/account?api_key=\(API.KEY)&session_id=\(sessionId)"
        
        return ROUTE_ACCOUNT_DETAIL
    }
    
    static func getRatedMovies(accountId: Int, sessionId: String) -> String {
        let ROUTE_RATED_MOVIES = "\(API.BASE_URL)/account/\(accountId)/rated/movies?api_key=\(API.KEY)&language=en-US&session_id=\(sessionId)&sort_by=created_at.asc&page=1"
        
        return ROUTE_RATED_MOVIES
    }
    
    static func getWatchMovies(accountId: Int,sessionId: String) ->String {
        let ROUTE_WATCH_LIST = "\(API.BASE_URL)/account/\(accountId)/watchlist/movies?api_key=\(API.KEY)&language=en-US&session_id=\(sessionId)&sort_by=created_at.asc&page=1"
        
        return ROUTE_WATCH_LIST
    }
    
    static func getAddRateMovie(sessionId: String, movieId: Int) -> String{
        let ROUTE_RATE_MOVIE = "\(API.BASE_URL)/movie/\(movieId)/rating?api_key=\(API.KEY)&session_id=\(sessionId)"
        
        return ROUTE_RATE_MOVIE
    }
    
    static func getAddWatchMovie(accountId: Int, sessionId: String) -> String{
        let ROUTE_RATE_MOVIE = "\(API.BASE_URL)/account/\(accountId)/watchlist?api_key=\(API.KEY)&session_id=\(sessionId)"
        
        return ROUTE_RATE_MOVIE
    }
}
