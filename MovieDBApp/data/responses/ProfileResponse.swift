//
//  ProfileResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
struct ProfileResponse : Codable {
    
    let failure : Bool?
    let status_code : Int?
    let status_message : String?
    
    let success : Bool?
    let expires_at : String?
    let request_token : String?
    
    let session_id : String?

}
