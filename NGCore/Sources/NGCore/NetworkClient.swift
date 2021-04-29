//
//  NetworkClient.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/27/21.
//

import Foundation

enum NetworkError : Error {
    case dataTask(Error)
    case noData
    case parseError(Error)
}

public class NetworkClient {

    let baseURL = URL(string: "https://hckrnews.com/data/")!

    func fetchLatest(completion: @escaping (Result<[Post], NetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("latest.js")

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.dataTask(error!))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data.dropFirst(14))
                DispatchQueue.main.async { completion(.success(posts)) }
            } catch {
                print(error)
                DispatchQueue.main.async { completion(.failure(.parseError(error))) }
            }
        }.resume()
    }
}