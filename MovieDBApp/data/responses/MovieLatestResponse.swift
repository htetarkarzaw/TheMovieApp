//
//  MovieLatestResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieLatestResponse : Codable{
    let adult: Bool
    let budget: Int
    let id: Int
    let original_title: String?
    let overview: String?
    let popularity: Double
    let release_date: String?
    let revenue: Int
    let runtime: Int
    let status: String?
    let tageline: String?
    let title: String?
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    static func saveMovieLatest(data : MovieLatestResponse, realm: Realm) {
        
        //TODO: Implement Save Realm object MovieGenreVO
        
        do {
            try realm.write {
                realm.add(convertToMovieLatestVO(data: data, realm: realm))
            }
        }catch {
            
        }
    }
    
    static func convertToMovieLatestVO(data : MovieLatestResponse, realm : Realm) -> MovieLatestVO {
        //TODO: Write Convert Logic
        let movieLatestVO = MovieLatestVO()
        
        movieLatestVO.adult = data.adult
        movieLatestVO.budget = data.budget
        
        movieLatestVO.id = data.id
        movieLatestVO.original_title = data.original_title
        movieLatestVO.overview = data.overview
        movieLatestVO.popularity = data.popularity
        movieLatestVO.release_date = data.release_date
        movieLatestVO.revenue = data.revenue
        movieLatestVO.runtime = data.runtime
        movieLatestVO.status = data.status
        movieLatestVO.tagline = data.tageline
        movieLatestVO.title = data.title
        movieLatestVO.video = data.video
        movieLatestVO.vote_count = data.vote_count
        movieLatestVO.vote_average = data.vote_average
        
        return movieLatestVO
    }

}
