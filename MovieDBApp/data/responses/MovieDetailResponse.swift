//
//  MovieDetailResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieDetailResponse : Codable {
    
    let adult: Bool?
    let budget: Int?
    let id : Int?
    let original_title : String?
    let overview : String?
    let popularity : Double?
    let backdrop_path : String?
    let release_date : String?
    let title : String?
    let vote_average : Double?
    let poster_path: String?
    let runtime: Int?
    
    enum CodingKeys:String,CodingKey {
        case adult,budget,id,original_title,overview,popularity,backdrop_path,release_date,title,vote_average,poster_path,runtime
    }
    
    static func saveMovieDetail(data : MovieDetailResponse, realm : Realm) {
        //TODO: Implement Realm Save Movie Logic
        
        let movie = realm.object(ofType: MovieDetailVO.self, forPrimaryKey: data.id)
        
        do {
            
            if let mMovie = movie {
                
                try realm.write {
                    mMovie.adult = data.adult ?? false
                    mMovie.budget = data.budget ?? 0
                    mMovie.backdrop_path = data.backdrop_path
                    mMovie.original_title = data.original_title
                    mMovie.overview = data.overview
                    mMovie.popularity = data.popularity ?? 0
                    mMovie.release_date = data.release_date
                    mMovie.title = data.title
                    mMovie.vote_average = data.vote_average ?? 0.0
                    mMovie.poster_path = data.poster_path
                    mMovie.runtime = data.runtime ?? 0
                }
                
            } else{
                try realm.write {
                    realm.add(convertToMovieDetailVO(data: data, realm: realm))
                }
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    static func convertToMovieDetailVO(data : MovieDetailResponse, realm : Realm) -> MovieDetailVO {
        //TODO: Write Convert Logic
        let movieVO = MovieDetailVO()
        
        movieVO.id = data.id ?? 0
        movieVO.adult = data.adult ?? false
        movieVO.budget = data.budget ?? 0
        movieVO.backdrop_path = data.backdrop_path
        movieVO.original_title = data.original_title
        movieVO.overview = data.overview
        movieVO.popularity = data.popularity ?? 0
        movieVO.release_date = data.release_date
        movieVO.title = data.title
        movieVO.vote_average = data.vote_average ?? 0.0
        movieVO.poster_path = data.poster_path
        movieVO.runtime = data.runtime ?? 0
        
        return movieVO
    }
    
}
