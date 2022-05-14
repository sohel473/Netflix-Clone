//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/11/22.
//

import UIKit

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    static let shared = APICaller()
    private let baseURL = "https://api.themoviedb.org"
    private let API_KEY = "d537efe84ac70e422039c632f3907c23"
    private let YouTube_baseURL = "https://youtube.googleapis.com/youtube/v3/search?"
//    private let YouTube_API_KEY1 = "AIzaSyAWgmuN6Bb8BFV_p-gIxv8OY1KUZW7RKgg"
    private let YouTube_API_KEY2 = "AIzaSyCAJsBNySy-HqREsSJnitMCK2OwDEVmCHY"
    
    private init () {}
    
    //MARK: - Get Trending Movies
    func getTrendingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/trending/movie/day?api_key=\(API_KEY)"
        //        print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
//                                print(results)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Trending Tvs
    func getTrendingTvs(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/trending/tv/day?api_key=\(API_KEY)"
        //        print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Popular Movies
    func getPopularMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/movie/popular?api_key=\(API_KEY)"
        //                print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Upcoming Movies
    func getUpcomingMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/movie/upcoming?api_key=\(API_KEY)"
        //                print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Top Rated Movies
    func getTopRatedMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/movie/top_rated?api_key=\(API_KEY)"
        //                print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Discover Movies
    func getDiscoverMovies(completion: @escaping(Result<[Title], Error>) -> Void) {
        let endpoint = "\(baseURL)/3/discover/movie?api_key=\(API_KEY)&&sort_by=popularity.desc&include_adult=false&include_video=false&with_watch_monetization_types=flatrate"
        //                print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Search Movies
    func search(with query: String, completion: @escaping(Result<[Title], Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
//        print(query)
        let endpoint = "\(baseURL)/3/search/movie?api_key=\(API_KEY)&query=\(query)"
        //        print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
                //                print("IN")
                let decoder = JSONDecoder()
                let results = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                //                print(results.results[0].original_title)
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    //MARK: - Get Movies
    func getMovies(query: String, completion: @escaping(Result<VideoElement, Error>) -> Void) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let endpoint = "\(YouTube_baseURL)q=\(query)&key=\(YouTube_API_KEY2)"
//        print(endpoint)
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  error == nil else {
                return
            }
            do {
//                 print("IN")
//                let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let decoder = JSONDecoder()
                let results = try decoder.decode(YoutubeSearchResponse.self, from: data)
                completion(.success(results.items[0]))
//                print(results)
//                items[0].id.videoId
                
            } catch {
                //                completion(.failure(APIError.failedToGetData))
                print(error)
            }
        }
        task.resume()
    }
}
