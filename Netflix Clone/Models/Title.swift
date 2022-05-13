//
//  Movie.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/12/22.
//

import Foundation

//MARK: - TrendingMovieResponse
struct TrendingTitleResponse: Codable {
    let results: [Title]
}

// MARK: - Result
struct Title: Codable {
    let original_title, original_name, poster_path: String?
    let vote_average: Double
    let id: Int
    let overview, release_date: String?
    let vote_count: Int
    let media_type: String?
}
