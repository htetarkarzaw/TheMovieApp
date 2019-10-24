//
//  ProfileModel.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 25/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

class ProfileModel {
    
    static let shared = ProfileModel()
    
    private init() {}
    
    func fetchProfileDetail(sessionId: String, completion : @escaping (ProfileDetailResponse) -> Void) {
        let route = URL(string: Routes.getAccountDetail(sessionId: sessionId))!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : ProfileDetailResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func fetchRequestToken(completion : @escaping (ProfileResponse) -> Void) {
        let route = URL(string: Routes.ROUTE_REQUEST_TOKEN)!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : ProfileResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func fetchLoginValidate(username: String, password: String, requestToken : String, completion : @escaping (ProfileResponse) -> Void) {
        
        //        let json: [String: Any] = ["title": "ABC",
        //                                   "dict": ["1":"First", "2":"Second"]]
        
        let json: [String: Any] = [
            "username" : username,
            "password" : password,
            "request_token": requestToken]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let route = URL(string: Routes.ROUTE_VALIDATE_LOGIN)!

        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : ProfileResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func fetchSessionByRequestToken(requestToken : String, completion : @escaping (ProfileResponse) -> Void) {
        
//        let json: [String: Any] = ["title": "ABC",
//                                   "dict": ["1":"First", "2":"Second"]]
        
        let json: [String: Any] = ["request_token": requestToken]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let route = URL(string: Routes.ROUTE_CREATE_SESSION)!
        var request = URLRequest(url: route)
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            let response : ProfileResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
            if let data = response {
                completion(data)
            }
            }.resume()
    }
    
    func responseHandler<T : Decodable>(data : Data?, urlResponse : URLResponse?, error : Error?) -> T? {
        let TAG = String(describing: T.self)
        if error != nil {
            print("\(TAG): failed to fetch data : \(error!.localizedDescription)")
            return nil
        }
        
        let response = urlResponse as! HTTPURLResponse
        
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
