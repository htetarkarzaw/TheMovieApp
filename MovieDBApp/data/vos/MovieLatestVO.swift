//
//  MovieLatestVO.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

class MovieLatestVO : Object {
    
    @objc dynamic var adult: Bool = false
    @objc dynamic var budget: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var original_title: String?
    @objc dynamic var overview: String?
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var release_date: String?
    @objc dynamic var revenue: Int = 0
    @objc dynamic var runtime: Int = 0
    @objc dynamic var status: String?
    @objc dynamic var tagline: String?
    @objc dynamic var title: String?
    @objc dynamic var video: Bool = false
    @objc dynamic var vote_average: Double = 0.0
    @objc dynamic var vote_count: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension MovieLatestVO {
    static func getMovieLatestById(movieId : Int, realm : Realm) -> MovieLatestVO? {
        //TODO: Implement realm object fetch API
        let movieVO = realm.object(ofType: MovieLatestVO.self, forPrimaryKey: movieId)
        
        return movieVO
    }
}
