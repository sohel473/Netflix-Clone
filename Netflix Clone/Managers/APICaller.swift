//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/11/22.
//

import UIKit

class APICaller {
    
    static let shared = APICaller()
    private let baseURL = "https://api.themoviedb.org"
    private let API_KEY = "d537efe84ac70e422039c632f3907c23"
    
    private init () {}
    
    
    func getTrendingMovies(completion: @escaping(String) -> Void) {
        let endpoint = "\(baseURL)/3/trending/movie/week?api_key=\(baseURL)"
        print(endpoint)
        
        guard let url = URL(string: endpoint) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data {
                    return
            }
            do {
                let decoder = JSONDecoder()
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
