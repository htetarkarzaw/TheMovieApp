//
//  MovieListResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieListResponse : Codable {
    let page : Int
    let total_results : Int
    let total_pages : Int
    let results : [MovieInfoResponse]
}
