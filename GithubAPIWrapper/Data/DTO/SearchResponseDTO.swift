//
//  SearchResponseDTO.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 09/02/26.
//

struct SearchResponseDTO: Codable {
    let total_count: Int
    let items: [ProfileDTO]
}
