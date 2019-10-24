//
//  ProfileDetailResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct ProfileDetailResponse : Codable {
    
    let id: Int?
    let name: String?
    let username: String?
  
}
