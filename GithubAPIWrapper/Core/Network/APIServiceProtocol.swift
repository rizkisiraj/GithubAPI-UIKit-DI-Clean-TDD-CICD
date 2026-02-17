//
//  APIServiceProtocol.swift
//  GithubAPIWrapper
//
//  Created by Rizki Siraj on 17/02/26.
//

import Combine

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(url: String) -> AnyPublisher<T, Error>
}

