//
//  MovieTrailerListResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieTrailerListResponse : Codable {
    let id : Int
    let results : [MovieTrailerInfoResponse]
}
