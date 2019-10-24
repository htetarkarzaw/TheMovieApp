//
//  MovieInfoResponse.swift
//  MovieDBApp
//
//  Created by Htet Arkar Zaw on 24/10/2019.
//  Copyright © 2019 Htet Arkar Zaw. All rights reserved.
//

import Foundation
import RealmSwift

struct MovieInfoResponse : Codable {
    
    let popularity : Double?
    let vote_count : Int?
    let video : Bool?
    let poster_path : String?
    let id : Int?
    let adult : Bool?
    let backdrop_path : String?
    let original_language : String?
    let original_title : String?
    let genre_ids: [Int]?
    let title : String?
    let vote_average : Double?
    let overview : String?
    let release_date : String?
    let budget : Int?
    let homepage : String?
    let imdb_id : String?
    let revenue : Int?
    let runtime : Int?
    let tagline : String?
    
    //Production Companies
    //TODO: Parse Production Companies
    
    enum CodingKeys:String,CodingKey {
        case popularity
        case vote_count
        case video
        case poster_path
        case id
        case adult
        case backdrop_path
        case original_language
        case original_title
        case genre_ids
        case title
        case vote_average
        case overview
        case release_date
        case budget
        case homepage
        case imdb_id
        case revenue
        case runtime
        case tagline = "tagline"
    }
    
    static func updateMovie(movieId: Int, realm: Realm, movieType: String) {
        let movie = realm.object(ofType: MovieVO.self, forPrimaryKey: movieId)
        
        switch movieType {
        case "rated":
            if let mMovie = movie {
                try! realm.write {
                    mMovie.rated = true
                }
            }
            break
            
        case "watch":
            if let mMovie = movie {
                try! realm.write {
                    mMovie.watch = true
                }
            }
            break
        default:
            break
        }
    }
    
    static func saveMovie(data : MovieInfoResponse, realm : Realm, movieType : String) {
        //TODO: Implement Realm Save Movie Logic
        
        let movie = realm.object(ofType: MovieVO.self, forPrimaryKey: data.id)
        
        switch movieType {
        case "trending":
            do {
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.trending = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
                
            } catch {
                print(error.localizedDescription)
            }
            break
        case "nowplaying":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.now_showing = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
        case "upcoming":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.up_coming = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm,movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
        case "toprated":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.top_rated = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
        case "searched":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.searched = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
            
        case "rated":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.rated = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
            
        case "watch":
            do {
                
                if let mMovie = movie {
                    try! realm.write {
                        mMovie.watch = true
                    }
                } else{
                    try realm.write {
                        realm.add(convertToMovieVO(data: data, realm: realm, movieType: movieType))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            break
        default:
            break
        }
        
    }
    
    static func convertToMovieVO(data : MovieInfoResponse, realm : Realm, movieType : String) -> MovieVO {
        //TODO: Write Convert Logic
        let movieVO = MovieVO()
        
        movieVO.id = data.id ?? 0
        movieVO.adult = data.adult ?? false
        movieVO.backdrop_path = data.backdrop_path
        movieVO.budget = data.budget ?? 0
        
        if let gids = data.genre_ids {
            for genreid in gids {
                if let genreVO = realm.object(ofType: MovieGenreVO.self, forPrimaryKey: genreid) {
                    movieVO.genres.append(genreVO)
                }
            }
        }
        
        movieVO.homepage = data.homepage
        movieVO.imdb_id = data.imdb_id
        movieVO.original_language = data.original_language
        movieVO.original_title = data.original_title
        movieVO.overview = data.overview
        movieVO.popularity = data.popularity ?? 0.0
        movieVO.poster_path = data.poster_path
        movieVO.release_date = data.release_date
        movieVO.revenue = data.revenue ?? 0
        movieVO.vote_count = data.vote_count ?? 0
        
        switch movieType {
        case "nowplaying":
            movieVO.now_showing = true
            break;
        case "upcoming":
            movieVO.up_coming = true
            break
        case "trending":
            movieVO.trending = true
            break
        case "toprated":
            movieVO.top_rated = true
            break
        case "searched":
            movieVO.searched = true
        case "rated":
            movieVO.rated = true
        case "watch":
            movieVO.watch = true
        default:
            break
        }
        
        return movieVO
    }
}
