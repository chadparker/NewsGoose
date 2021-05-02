//
//  PostNetworkFetcher.swift
//  NewsGoose
//
//  Created by Chad Parker on 4/27/21.
//

import Foundation

public enum PostNetworkError : Error {
    case dataTask(Error)
    case noData
    case parseError(Error)
}

public class PostNetworkFetcher {

    let baseURL = URL(string: "https://hckrnews.com/data/")!

    func fetchLatest(completion: @escaping (Result<[Post], PostNetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("latest.js")

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.dataTask(error!))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            do {
                // The `latest.js` file starts with `var entries = `. remove for valid JSON:
                let trimmedData = data.dropFirst(14)
                let posts = try JSONDecoder().decode([Post].self, from: trimmedData)
                DispatchQueue.main.async { completion(.success(posts)) }
            } catch {
                print(error)
                DispatchQueue.main.async { completion(.failure(.parseError(error))) }
            }
        }.resume()
    }

    func fetchDay(_ day: String, completion: @escaping (Result<[Post], PostNetworkError>) -> Void) {
        let url = baseURL.appendingPathComponent("\(day).js")

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async { completion(.failure(.dataTask(error!))) }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }

            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                DispatchQueue.main.async { completion(.success(posts)) }
            } catch {
                print(error)
                DispatchQueue.main.async { completion(.failure(.parseError(error))) }
            }
        }.resume()
    }
}
