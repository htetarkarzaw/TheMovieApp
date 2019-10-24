//
//  MovieDetailModel.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

class MovieDetailModel {
    static let shared = MovieDetailModel()
    
    private init() {}
    
    func fetchMovieDetailById(movieId : Int, completion : @escaping (MovieDetailResponse) -> Void) {
        let route = URL(string: Routes.getDetail(movieId: movieId))!
        URLSession.shared.dataTask(with: route) { (data, urlResponse, error) in
            let response : MovieDetailResponse? = self.responseHandler(data: data, urlResponse: urlResponse, error: error)
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
        
        if response.statusCode == 200 {
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
        } else {
            print("\(TAG): Network Error - Code: \(response.statusCode)")
            return nil
        }
    }
    
}

