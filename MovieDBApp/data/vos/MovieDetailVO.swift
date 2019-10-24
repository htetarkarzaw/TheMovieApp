//
//  MovieDetailVO.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

class MovieDetailVO : Object {
    
    @objc dynamic var adult: Bool = false
    @objc dynamic var budget: Int = 0
    @objc dynamic var id : Int = 0
    @objc dynamic var original_title : String?
    @objc dynamic var overview : String?
    @objc dynamic var popularity : Double = 0.0
    @objc dynamic var backdrop_path : String?
    @objc dynamic var release_date : String?
    @objc dynamic var title : String?
    @objc dynamic var vote_average : Double = 0.0
    @objc dynamic var poster_path: String?
    @objc dynamic var runtime: Int = 0
    
    //Production Companies
    //TODO: Save Production Companies
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


extension MovieDetailVO {
    static func getMovieById(movieId : Int, realm : Realm) -> MovieDetailVO? {
        //TODO: Implement realm object fetch API
        let movieVO = realm.object(ofType: MovieDetailVO.self, forPrimaryKey: movieId)
        
        return movieVO
    }
}
